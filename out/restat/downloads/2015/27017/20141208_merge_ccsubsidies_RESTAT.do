
/*******************************
PART 1: merge in data
*******************************/

*0. create sampe of 4 year olds.

use "/data/befdta/befmaster.dta"
keep pid fpid mpid foedselsaar bmonth statuskode
drop if mpid==. & fpid==.
keep if foedselsaar>1985
keep if foedselsaar<1994
save "/home/katrine/ccsubsidies/20111304_age5max.dta"

*1. - merge in income - work with income variable

* a) mother
use  "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
save  "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/data/regdta/pearn6700wide.dta"
rename pid mpid
sort mpid
merge mpid using  "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1

gen mothermissingincallyears=1 if _merge==2
replace mothermissingincallyears=0 if mothermissingincallyears==.

drop _merge

local i = 1967
   while `i' <=2000{
      rename pearn`i' minc`i'
   local i = `i' + 1
   }

order pid fpid mpid foedselsaar bmonth statuskode mothermissingincallyears

*2000-2007
set more off
use "/home1/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace

local i = 2000
   while `i' <=2007{
use "/data/regdta/adssb`i'.dta"
keep pid pearn
rename pid mpid
rename pearn minc`i'
sort mpid
merge mpid using  "/home1/katrine/temp.dta"
tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

use "/home1/katrine/temp.dta"
sort mpid
merge mpid using   "/home1/katrine/ccsubsidies/20111304_age5max.dta"
drop if _merge==1
drop _merge
save "/home1/katrine/ccsubsidies/20111304_age5max.dta", replace


*b)father

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/data/regdta/pearn6700wide.dta"
rename pid fpid
sort fpid
merge fpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1

gen fathermissingincallyears=1 if _merge==2
replace fathermissingincallyears=0 if fathermissingincallyears==.

drop _merge

local i = 1967
   while `i' <=2000{
      rename pearn`i' finc`i'
   local i = `i' + 1
   }

order pid fpid mpid foedselsaar bmonth statuskode mothermissingincallyears fathermissingincallyears

*2000-2007
set more off
use "/home1/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep fpid
sort fpid
save "/home1/katrine/temp.dta", replace

local i = 2000
   while `i' <=2007{
use "/data/regdta/adssb`i'.dta"
keep pid pearn
rename pid fpid
rename pearn finc`i'
sort fpid
merge fpid using  "/home1/katrine/temp.dta"
tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

use "/home1/katrine/temp.dta"
sort fpid
merge fpid using   "/home1/katrine/ccsubsidies/20111304_age5max.dta"
drop if _merge==1
drop _merge
save "/home1/katrine/ccsubsidies/20111304_age5max.dta", replace

*c) gen different family income variables - 1980-1992

*faminc1:family income is missing if both mother and father income is missing, otherwise set missing to 0 and add mother+father income.

local i = 1980
   while `i' <=2000{
	gen finc2`i'=finc`i'
	gen minc2`i'=minc`i'
	replace finc2`i'=0 if finc2`i'==. & minc2`i'!=.
	replace minc2`i'=0 if finc2`i'!=. & minc2`i'==.
	gen faminc`i'_1=finc2`i'+minc2`i'
	drop finc2`i'
	drop minc2`i'
   local i = `i' + 1
   }
   
   local i = 2001
   while `i' <=2007{
	gen finc2`i'=finc`i'
	gen minc2`i'=minc`i'
	replace finc2`i'=0 if finc2`i'==. & minc2`i'!=.
	replace minc2`i'=0 if finc2`i'!=. & minc2`i'==.
	gen faminc`i'_1=finc2`i'+minc2`i'
	drop finc2`i'
	drop minc2`i'
   local i = `i' + 1
   }


*2. merge in information on parents background - what do we need??

*a) mother  - adssb-files 1986-1993 +2006

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

local i = 1986
   while `i' <=1993{
use "/data/regdta/adssb`i'.dta"
keep pid age mstat komres citz eduy
rename pid mpid
rename age mage`i'
rename mstat mstat`i'
rename komres mkom`i'
rename citz mcitz`i'
rename eduy meduy`i'
sort mpid
merge mpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace
 local i = `i' + 1
   }

use "/data/regdta/adssb2006.dta"
keep pid age mstat komres citz eduy
rename pid mpid
rename age mage2006
rename mstat mstat2006
rename komres mkom2006
rename citz mcitz2006
rename eduy meduy2006
sort mpid
merge mpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace



*b) father  - adssb-files 1986-1992 +2006

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

local i = 1986
   while `i' <=1992{
use "/data/regdta/adssb`i'.dta"
keep pid age mstat komres citz eduy
rename pid fpid
rename age fage`i'
rename mstat fmstat`i'
rename komres fkom`i'
rename citz fcitz`i'
rename eduy feduy`i'
sort fpid
merge fpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace
 local i = `i' + 1
   }

use "/data/regdta/adssb2006.dta"
keep pid age mstat komres citz eduy
rename pid fpid
rename age fage2006
rename mstat fstat2006
rename komres fmkom2006
rename citz fcitz2006
rename eduy feduy2006
sort fpid
merge fpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*c)

order pid foedselsaar bmonth statuskode mpid meduy1986 meduy1987 meduy1988 meduy1989 meduy1990 meduy1991 meduy1992 meduy1993 meduy2006 mcitz1986 mcitz1987 mcitz1988 mcitz1989 mcitz1990 mcitz1991 mcitz1992 mcitz1993 mcitz2006 mkom1986 mkom1987 mkom1988 mkom1989 mkom1990 mkom1991 mkom1992 mkom1993 mkom2006 mstat1986 mstat1987 mstat1988 mstat1989 mstat1990 mstat1991 mstat1992 mstat1993 mstat2006 mage1986 mage1987 mage1988 mage1989 mage1990 mage1991 mage1992 mage1993 mage2006 fpid feduy1986 feduy1987 feduy1988 feduy1989 feduy1990 feduy1991 feduy1992 feduy1993 feduy2006 fcitz1986 fcitz1987 fcitz1988 fcitz1989 fcitz1990 fcitz1991 fcitz1992 fcitz1993 fcitz2006 fkom1986 fkom1987 fkom1988 fkom1989 fkom1990 fkom1991 fkom1992 fkom1993 fmkom2006 fmstat1986 fmstat1987 fmstat1988 fmstat1989 fmstat1990 fmstat1991 fmstat1992 fmstat1993 fstat2006 fage1986 fage1987 fage1988 fage1989 fage1990 fage1991 fage1992 fage1993 fage2006


3. merge in children's grades

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use "/data/utddta/grunnskar0209.dta"

sort pid
by pid: egen stpaver=mean(stp)

by pid: egen munaver=mean(mun)

by pid: egen skraver=mean(skr)


sort pid
drop if pid==pid[_n-1]

sort pid

keep pid stpaver munaver skraver

merge pid using   "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge
drop if _merge==1

gen missingallgrades=1 if _merge==2
replace missingallgrades=0 if missingallgrades==.

drop _merge

order pid foedselsaar bmonth statuskode skraver munaver stpaver missingallgrades

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


4. child care data

*start using temp. dataset 

*mother 
set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace

local i = 1993
   while `i' <=1997{
use "/data/sjukedta/stonad`i'.dta"
keep pid post3210
rename pid mpid
rename post3210 mdeduc`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }


use "/home1/katrine/temp.dta"
sort mpid
save "/home1/katrine/temp.dta", replace


local i = 1998
   while `i' <=1999{
use "/data/sjukedta/stonad`i'.dta"
keep pid bel_1_32
rename pid mpid
rename bel_1_32 mdeduc`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }

local i = 2000
   while `i' <=2001{
use "/data/sjukedta/stonad`i'.dta"
keep pid bel_1_33
rename pid mpid
rename bel_1_33 mdeduc`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }

local i = 2002
   while `i' <=2005{
use "/data/sjukedta/stonad`i'.dta"
keep pid bel_1_32
rename pid mpid
rename bel_1_32 mdeduc`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }

order mpid mdeduc1993 mdeduc1994 mdeduc1995 mdeduc1996 mdeduc1997 mdeduc1998 mdeduc1999 mdeduc2000 mdeduc2001 mdeduc2002 mdeduc2003 mdeduc2004 mdeduc2005
sum mdeduc1993 mdeduc1994 mdeduc1995 mdeduc1996 mdeduc1997 mdeduc1998 mdeduc1999 mdeduc2000 mdeduc2001 mdeduc2002 mdeduc2003 mdeduc2004 mdeduc2005


use "/home1/katrine/temp.dta"
sort mpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
merge mpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*father
set more off
use  "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep fpid
sort fpid
save "/home1/katrine/temp.dta", replace

local i = 1993
   while `i' <=1997{
use "/data/sjukedta/stonad`i'.dta"
keep pid post3210
rename pid fpid
rename post3210 fdeduc`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }


use "/home1/katrine/temp.dta"
sort fpid
save "/home1/katrine/temp.dta", replace


local i = 1998
   while `i' <=1999{
use "/data/sjukedta/stonad`i'.dta"
keep pid bel_1_32
rename pid fpid
rename bel_1_32 fdeduc`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }

local i = 2000
   while `i' <=2001{
use "/data/sjukedta/stonad`i'.dta"
keep pid bel_1_33
rename pid fpid
rename bel_1_33 fdeduc`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }

local i = 2002
   while `i' <=2005{
use "/data/sjukedta/stonad`i'.dta"
keep pid bel_1_32
rename pid fpid
rename bel_1_32 fdeduc`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }

order fpid fdeduc1993 fdeduc1994 fdeduc1995 fdeduc1996 fdeduc1997 fdeduc1998 fdeduc1999 fdeduc2000 fdeduc2001 fdeduc2002 fdeduc2003 fdeduc2004 fdeduc2005
sum fdeduc1993 fdeduc1994 fdeduc1995 fdeduc1996 fdeduc1997 fdeduc1998 fdeduc1999 fdeduc2000 fdeduc2001 fdeduc2002 fdeduc2003 fdeduc2004 fdeduc2005


use "/home1/katrine/temp.dta"
sort fpid
save "/home1/katrine/temp.dta", replace

use  "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
merge fpid using "/home1/katrine/temp.dta"

drop _merge
save  "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*add mothers + fathers deduction: first set missing to 0 (note that otherwise we will not get any child not in chidl care between 93-97 since 0 is not registered, this is otherwise from 1998)

local i = 1993
   while `i' <=2005{
replace mdeduc`i'=0 if mdeduc`i'==. 
replace fdeduc`i'=0 if fdeduc`i'==. 
gen famdeduc`i'=fdeduc`i'+mdeduc`i'
 local i = `i' + 1
   }
   
*to otain same "numbers" divide 1998 by 10

local i = 1998
   while `i' <=2005{
replace famdeduc`i'=famdeduc`i'/10
 local i = `i' + 1
   }


sum famdeduc1993 famdeduc1994 famdeduc1995 famdeduc1996 famdeduc1997 famdeduc1998 famdeduc1999 famdeduc2000 famdeduc2001 famdeduc2002 famdeduc2003 famdeduc2004 famdeduc2005

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

6. married/cohabitation - 1987-1992
* use bef-files, include information on familytype (married/cohab), marital status, number of kids

*a) mother  - bef-files 1987-1992 

set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace


local i = 1987
   while `i' <=1993{
use "/data/befdta/bef`i'.dta"
keep pid famt mstat nkids
rename pid mpid
rename famt mfamt`i'
rename mstat mstat_bef`i'
rename nkids mnkids`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"


tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

order mpid mfamt1987 mfamt1988 mfamt1989 mfamt1990 mfamt1991 mfamt1992 mfamt1993 mstat_bef1987 mstat_bef1988 mstat_bef1989 mstat_bef1990 mstat_bef1991 mstat_bef1992 mstat_bef1993 mnkids1987 mnkids1988 mnkids1989 mnkids1990 mnkids1991 mnkids1992 mnkids1993
sort mpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
merge mpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*b) father  - bef-files 1987-1992 

set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep fpid
sort fpid
save "/home1/katrine/temp.dta", replace


local i = 1987
   while `i' <=1993{
use "/data/befdta/bef`i'.dta"
keep pid famt mstat nkids
rename pid fpid
rename famt ffamt`i'
rename mstat fmstat_bef`i'
rename nkids fnkids`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"


tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

order fpid ffamt1987 ffamt1988 ffamt1989 ffamt1990 ffamt1991 ffamt1992 ffamt1993 fmstat_bef1987 fmstat_bef1988 fmstat_bef1989 fmstat_bef1990 fmstat_bef1991 fmstat_bef1992 fmstat_bef1993 fnkids1987 fnkids1988 fnkids1989 fnkids1990 fnkids1991 fnkids1992 fnkids1993
sort fpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
merge fpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace



7. social security -92-98

*a) mother

set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace

use "/home1/katrine/childcare/welfare_recipients.dta"

duplicates drop
rename shjaar year
drop if year>1998
keep mndutbet pid year
su
tab mndutbet
drop if mndutbet==0
rename mndutbet mmndutbet

sort pid year
reshape wide mmndutbet, i(pid) j(year)
su
sort pid

rename pid mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge
keep if _merge==2 | _merge==3
drop _merge
su
sort mpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
merge mpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*a) father

set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep fpid
sort fpid
save "/home1/katrine/temp.dta", replace

use "/home1/katrine/childcare/welfare_recipients.dta"

duplicates drop
rename shjaar year
drop if year>1997
keep mndutbet pid year
su
tab mndutbet
drop if mndutbet==0
rename mndutbet fmndutbet

sort pid year
reshape wide fmndutbet, i(pid) j(year)
su
sort pid

rename pid fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge
keep if _merge==2 | _merge==3
drop _merge
su
sort fpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
merge fpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace



*8. municipalities also from 1994-1998 from adssb - both mother and fatheruse "/home1/katrine/childcare/88_92newaug10.dta"

*a) mother
set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace

local i = 1994
   while `i' <=1998{
use "/data/regdta/adssb`i'.dta"
keep pid komres 
rename pid mpid
rename komres mkom`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp", replace
 local i = `i' + 1
   }

sort mpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
merge mpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

order pid- mkom1993 mkom1994 mkom1995 mkom1996 mkom1997 mkom1998

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*b) father
set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep fpid
sort fpid
save "/home1/katrine/temp.dta", replace

local i = 1994
   while `i' <=1998{
use "/data/regdta/adssb`i'.dta"
keep pid komres 
rename pid fpid
rename komres fkom`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp", replace
 local i = `i' + 1
   }

sort fpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
merge fpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

order pid- fkom1993 fkom1994 fkom1995 fkom1996 fkom1997 fkom1998

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace



*9. price and income cutoffs data

*a) mother 1991-1998

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mkom1991
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


use "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff191-cutoff2791  kommune infoonincome flat info siblingreduction95 price911-price9128

forvalues i=1(1)27{ 
rename cutoff`i'91 mcutoff`i'91
rename price91`i' mprice91`i'

}

rename price9128 mprice9128
rename kommune mkom1991
rename flat mflat1991
rename info minfo1991
rename siblingreduction95 msibred1991
rename infoonincome minfinc1991

sort mkom1991
merge mkom1991 using  "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1991 if _merge==2

drop _merge
count

order pid- fmndutbet1997

sort mkom1992
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff192-cutoff2792  kommune infoonincome flat info siblingreduction95 price921-price9228

forvalues i=1(1)27{ 
rename cutoff`i'92 mcutoff`i'92
rename price92`i' mprice92`i'

}

rename price9228 mprice9228
rename kommune mkom1992
rename flat mflat1992
rename info minfo1992
rename siblingreduction95 msibred1992
rename infoonincome minfinc1992

sort mkom1992
merge mkom1992 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1992 if _merge==2

drop _merge
count

order pid-mprice9128

sort mkom1993
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff193-cutoff2793  kommune infoonincome flat info siblingreduction95 price931-price9328

forvalues i=1(1)27{ 
rename cutoff`i'93 mcutoff`i'93
rename price93`i' mprice93`i'

}

rename price9328 mprice9328
rename kommune mkom1993
rename flat mflat1993
rename info minfo1993
rename siblingreduction95 msibred1993
rename infoonincome minfinc1993

sort mkom1993
merge mkom1993 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1993 if _merge==2

drop _merge
count

order pid-mprice9228

sort mkom1994
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff194-cutoff2794  kommune infoonincome flat info siblingreduction95 price941-price9428

forvalues i=1(1)27{ 
rename cutoff`i'94 mcutoff`i'94
rename price94`i' mprice94`i'

}

rename price9428 mprice9428
rename kommune mkom1994
rename flat mflat1994
rename info minfo1994
rename siblingreduction95 msibred1994
rename infoonincome minfinc1994

sort mkom1994
merge mkom1994 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1994 if _merge==2

drop _merge
count

order pid-mprice9328

sort mkom1995
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff195-cutoff2795  kommune infoonincome flat info siblingreduction95 price951-price9528

forvalues i=1(1)27{ 
rename cutoff`i'95 mcutoff`i'95
rename price95`i' mprice95`i'

}

rename price9528 mprice9528
rename kommune mkom1995
rename flat mflat1995
rename info minfo1995
rename siblingreduction95 msibred1995
rename infoonincome minfinc1995

sort mkom1995
merge mkom1995 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1995 if _merge==2

drop _merge
count

order pid-mprice9428

sort mkom1996
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff196-cutoff2796  kommune infoonincome flat info siblingreduction95 price961-price9628

forvalues i=1(1)27{ 
rename cutoff`i'96 mcutoff`i'96
rename price96`i' mprice96`i'

}

rename price9628 mprice9628
rename kommune mkom1996
rename flat mflat1996
rename info minfo1996
rename siblingreduction95 msibred1996
rename infoonincome minfinc1996

sort mkom1996
merge mkom1996 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1996 if _merge==2

drop _merge
count

order pid-mprice9528

sort mkom1997
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff197-cutoff2797  kommune infoonincome flat info siblingreduction95 price971-price9728

forvalues i=1(1)27{ 
rename cutoff`i'97 mcutoff`i'97
rename price97`i' mprice97`i'

}

rename price9728 mprice9728
rename kommune mkom1997
rename flat mflat1997
rename info minfo1997
rename siblingreduction95 msibred1997
rename infoonincome minfinc1997

sort mkom1997
merge mkom1997 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1997 if _merge==2

drop _merge
count

order pid-mprice9628

sort mkom1998
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use  "/home1/katrine/ccsubsidies/cutoffsandprices.dta"
keep  cutoff198-cutoff2798  kommune infoonincome flat info siblingreduction95 price981-price9828

forvalues i=1(1)27{ 
rename cutoff`i'98 mcutoff`i'98
rename price98`i' mprice98`i'

}

rename price9828 mprice9828
rename kommune mkom1998
rename flat mflat1998
rename info minfo1998
rename siblingreduction95 msibred1998
rename infoonincome minfinc1998

sort mkom1998
merge mkom1998 using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
tab mkom1998 if _merge==2

drop _merge
count

order pid-mprice9728

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*10. birth year and closness of siblings

use  "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
save  "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

clear
use "/data/befdta/befmaster.dta"
keep pid mpid fpid foedselsaar
drop if mpid==. & fpid==.

sort mpid foedselsaar
order mpid foedselsaar
gen sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1986 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1987 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1988 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1989 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1990 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1991 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1992 & mpid!=.
replace sfaarolder1= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1993 & mpid!=.

sort mpid fpid foedselsaar
order mpid fpid foedselsaar
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1986 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1987 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1988 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1989 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1990 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1991 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1992 & fpid!=. & mpid==.
replace sfaarolder1= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1993 & fpid!=. & mpid==.

order mpid fpid foedselsaar sfaarolder1

sort mpid foedselsaar
order mpid foedselsaar
gen sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1986 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1987 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1988 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1989 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1990 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1991 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1992 & mpid!=.
replace sfaarolder2= foedselsaar[_n-2] if mpid==mpid[_n-2] & foedselsaar==1993 & mpid!=.

sort mpid fpid foedselsaar
order mpid fpid foedselsaar
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1986 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1987 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1988 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1989 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1990 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1991 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1992 & fpid!=. & mpid==.
replace sfaarolder2= foedselsaar[_n-2] if fpid==fpid[_n-2] & foedselsaar==1993 & fpid!=. & mpid==.

order mpid fpid foedselsaar sfaarolder1

sort mpid foedselsaar
order mpid foedselsaar

gen sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1986 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1987 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1988 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1989 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1990 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1991 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1992 & mpid!=.
replace sfaaryounger1= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1993 & mpid!=.

sort mpid fpid foedselsaar
order mpid fpid foedselsaar
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1986 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1987 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1988 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1989 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1990 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1991 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1992 & fpid!=. & mpid==.
replace sfaaryounger1= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1993 & fpid!=. & mpid==.

order mpid foedselsaar sfaarolder1 sfaarolder2 sfaaryounger1

sort mpid  foedselsaar
order mpid  foedselsaar
gen sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1986 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1987 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1988 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1989 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1990 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1991 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1992 & mpid!=.
replace sfaaryounger2= foedselsaar[_n+2] if mpid==mpid[_n+2] & foedselsaar==1993 & mpid!=.

sort mpid fpid foedselsaar
order mpid fpid foedselsaar
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1986 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1987 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1988 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1989 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1990 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1991 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1992 & fpid!=. & mpid==.
replace sfaaryounger2= foedselsaar[_n+2] if fpid==fpid[_n+2] & foedselsaar==1993 & fpid!=. & mpid==.

order mpid fpid foedselsaar sfaaryounger2 sfaaryounger1 sfaarolder1 sfaarolder2 sfaaryounger1

keep if foedselsaar>=1986 & foedselsaar<=1993

drop mpid fpid foedselsaar

sort pid
merge pid using "/home/katrine/ccsubsidies/20111304_age5max.dta"
tab _merge
drop _merge
count

order pid-missingallgrades sfaarolder1 sfaarolder2 sfaaryounger1 sfaaryounger2

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*11: number and order of siblings

use  "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use "/data/befdta/befmaster.dta"
keep mpid fpid pid foedselsaar
sort mpid
drop if mpid==. & fpid==.

gen ss=1 if mpid==mpid[_n-1]   
replace ss=1 if mpid==mpid[_n+1] 

replace ss=2 if mpid==mpid[_n-2]
replace ss=2 if mpid==mpid[_n+2]

replace ss=3 if mpid==mpid[_n-3]
replace ss=3 if mpid==mpid[_n+3]

replace ss=4 if mpid==mpid[_n-4]
replace ss=4 if mpid==mpid[_n+4]

replace ss=5 if mpid==mpid[_n-5]
replace ss=5 if mpid==mpid[_n+5]

replace ss=6 if mpid==mpid[_n-6]
replace ss=6 if mpid==mpid[_n+6]

replace ss=7 if mpid==mpid[_n-7]
replace ss=7 if mpid==mpid[_n+7]

replace ss=8 if mpid==mpid[_n-8]
replace ss=8 if mpid==mpid[_n+8]

replace ss=9 if mpid==mpid[_n-9]
replace ss=9 if mpid==mpid[_n+9]

replace ss=10 if mpid==mpid[_n-10]
replace ss=10 if mpid==mpid[_n+10]

replace ss=11 if mpid==mpid[_n-11]
replace ss=11 if mpid==mpid[_n+11]

replace ss=12 if mpid==mpid[_n-12]
replace ss=12 if mpid==mpid[_n+12]

replace ss=13 if mpid==mpid[_n-13]
replace ss=13 if mpid==mpid[_n+13]

replace ss=14 if mpid==mpid[_n-14]
replace ss=14 if mpid==mpid[_n+14]

replace ss=15 if mpid==mpid[_n-15]
replace ss=15 if mpid==mpid[_n+15]

replace ss=16 if mpid==mpid[_n-16]
replace ss=16 if mpid==mpid[_n+16]

replace ss=17 if mpid==mpid[_n-17]
replace ss=17 if mpid==mpid[_n+17]

replace ss=ss[_n-1] if mpid==mpid[_n-1]

replace ss=. if mpid==.
replace ss=0 if ss==. & mpid!=.

tab ss


sort mpid fpid

replace ss=1 if fpid==fpid[_n-1] & mpid==.
replace ss=1 if fpid==fpid[_n+1] & mpid==. 

replace ss=2 if fpid==fpid[_n-2] & mpid==.  
replace ss=2 if fpid==fpid[_n+2] & mpid==. 

replace ss=3 if fpid==fpid[_n-3] & mpid==.  
replace ss=3 if fpid==fpid[_n+3] & mpid==. 

replace ss=4 if fpid==fpid[_n-4] & mpid==.  
replace ss=4 if fpid==fpid[_n+4] & mpid==. 

replace ss=5 if fpid==fpid[_n-5] & mpid==.  
replace ss=5 if fpid==fpid[_n+5] & mpid==. 

replace ss=6 if fpid==fpid[_n-6] & mpid==.  
replace ss=6 if fpid==fpid[_n+6] & mpid==. 

replace ss=7 if fpid==fpid[_n-7] & mpid==.  
replace ss=7 if fpid==fpid[_n+7] & mpid==. 

replace ss=8 if fpid==fpid[_n-8] & mpid==.  
replace ss=8 if fpid==fpid[_n+8] & mpid==. 

replace ss=9 if fpid==fpid[_n-9] & mpid==.  
replace ss=9 if fpid==fpid[_n+9] & mpid==.

replace ss=10 if fpid==fpid[_n-10] & mpid==.  
replace ss=10 if fpid==fpid[_n+10] & mpid==.  

replace ss=ss[_n-1] if fpid==fpid[_n-1] & mpid==.  

replace ss=0 if ss==. & mpid==.

*order
sort mpid foedselsaar
gen o=1 if mpid==mpid[_n+1]
replace o=2 if mpid==mpid[_n-1] 
replace o=3 if mpid==mpid[_n-2]
replace o=4 if mpid==mpid[_n-3]
replace o=5 if mpid==mpid[_n-4]
replace o=6 if mpid==mpid[_n-5]
replace o=7 if mpid==mpid[_n-6]
replace o=8 if mpid==mpid[_n-7]
replace o=9 if mpid==mpid[_n-8]
replace o=10 if mpid==mpid[_n-9]
replace o=11 if mpid==mpid[_n-10]
replace o=12 if mpid==mpid[_n-11]
replace o=13 if mpid==mpid[_n-12]
replace o=14 if mpid==mpid[_n-13]
replace o=15 if mpid==mpid[_n-14]
replace o=16 if mpid==mpid[_n-15]
replace o=17 if mpid==mpid[_n-16]
replace o=18 if mpid==mpid[_n-17]

replace o=. if mpid==.
replace o=1 if o==. & mpid!=.

sort mpid fpid foedselsaar
replace o=1 if fpid==fpid[_n+1] & mpid==.
replace o=2 if fpid==fpid[_n-1] & mpid==. 
replace o=3 if fpid==fpid[_n-2] & mpid==. 
replace o=4 if fpid==fpid[_n-3] & mpid==. 
replace o=5 if fpid==fpid[_n-4] & mpid==.  
replace o=6 if fpid==fpid[_n-5] & mpid==.   
replace o=7 if fpid==fpid[_n-6] & mpid==.  
replace o=8 if fpid==fpid[_n-7] & mpid==. 
replace o=9 if fpid==fpid[_n-8] & mpid==.  
replace o=10 if fpid==fpid[_n-9] & mpid==.  
replace o=11 if fpid==fpid[_n-10] & mpid==.  

replace o=1 if o==. & mpid==. 

tab o

sort pid
keep if foedselsaar>=1986 & foedselsaar<=1993
keep pid o ss
rename ss sosken
rename o order
merge pid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge
drop if _merge==1
drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*12: sex in 2008

use  "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

set mem 10000m
use "/data/regdta/adssb2008.dta"
keep pid sex
sort pid
drop if pid<3000000
merge pid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge
drop if _merge==1
drop _merge

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*military data

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use "/data/regdta/sesjon.dta"
keep pid  wgt hgt ability
sort pid
merge pid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge
drop if _merge==1
drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*education from 2008 file

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use "/data/regdta/adssb2008.dta"
keep pid  eduy
sort pid
merge pid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge
drop if _merge==1
drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*parents age and education from 2008 file
set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid fpid
sort mpid
save "/home1/katrine/temp.dta", replace

use "/data/regdta/adssb2008.dta"
keep pid  eduy age
rename pid mpid
rename eduy meduy08
rename age mage08
sort mpid
merge mpid using "/home1/katrine/temp.dta"

tab _merge
drop if _merge==1
drop _merge

sort fpid
save "/home1/katrine/temp.dta", replace

use "/data/regdta/adssb2008.dta"
keep pid  eduy age
rename pid fpid
rename eduy feduy08
rename age fage08
sort fpid
merge fpid using "/home1/katrine/temp.dta"

tab _merge
drop if _merge==1
drop _merge
save "/home1/katrine/temp.dta", replace


use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use "/home1/katrine/temp.dta"
keep mpid mage08 meduy08
sort mpid
merge mpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"
drop _merge

sort fpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

use "/home1/katrine/temp.dta"
keep fpid fage08 feduy08
sort fpid
merge fpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"
drop _merge
count
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*13: mother student at different ages* 1986-1998

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

local i = 1986
   while `i' <=1998{
use "/data/utddta/ongoing_edu_`i'.dta"
keep pid 
rename pid mpid
gen student`i'=1
sort mpid
merge mpid using "/home/katrine/ccsubsidies/20111304_age5max.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace
 local i = `i' + 1
   }


*extra mstat and mfamt to 2002
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace

local i = 1994
   while `i' <=2002{
use "/data/regdta/adssb`i'.dta"
keep pid mstat
rename mstat mstat`i'
rename pid mpid
sort mpid
merge mpid using  "/home1/katrine/temp.dta"

tab _merge

drop if _merge==1
drop _merge
sort mpid
save  "/home1/katrine/temp.dta", replace
 local i = `i' + 1
   }
   
local i = 1994
   while `i' <=2002{
use "/data/befdta/bef`i'.dta"
keep pid famt
rename pid mpid
rename famt mfamt`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"


tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

  
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
merge mpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

order pid-sfaaryounger2 mpid mage08 meduy08 student1986 student1987 student1988 student1989 student1990 student1991 student1992 student1993 student1994 student1995 student1996 student1997 student1998 meduy1986-mage2006 fpid fage08 feduy08

sort pid
drop if pid==pid[_n-1]
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*10. birth year and pid of clostest older and younger siblings

clear
use "/data/befdta/befmaster.dta"
keep pid mpid fpid foedselsaar
drop if mpid==. & fpid==.

sort mpid foedselsaar
order mpid foedselsaar
gen sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1986 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1987 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1988 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1989 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1990 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1991 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1992 & mpid!=.
replace sosfoedselsaarold= foedselsaar[_n-1] if mpid==mpid[_n-1] & foedselsaar==1993 & mpid!=.

gen sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1986 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1987 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1988 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1989 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1990 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1991 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1992 & mpid!=.
replace sospidold= pid[_n-1] if mpid==mpid[_n-1] & foedselsaar==1993 & mpid!=.

sort mpid fpid foedselsaar
order mpid fpid foedselsaar
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1986 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1987 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1988 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1989 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1990 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1991 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1992 & fpid!=. & mpid==.
replace sosfoedselsaarold= foedselsaar[_n-1] if fpid==fpid[_n-1] & foedselsaar==1993 & fpid!=. & mpid==.

replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1986 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1987 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1988 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1989 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1990 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1991 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1992 & fpid!=. & mpid==.
replace sospidold= pid[_n-1] if fpid==fpid[_n-1] & foedselsaar==1993 & fpid!=. & mpid==.


order mpid fpid foedselsaar

sort mpid foedselsaar
order mpid foedselsaar
gen sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1986 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1987 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1988 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1989 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1990 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1991 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1992 & mpid!=.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if mpid==mpid[_n+1] & foedselsaar==1993 & mpid!=.

gen sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1986 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1987 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1988 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1989 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1990 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1991 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1992 & mpid!=.
replace sospidyoung= pid[_n+1] if mpid==mpid[_n+1] & foedselsaar==1993 & mpid!=.

sort mpid fpid foedselsaar
order mpid fpid foedselsaar
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1986 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1987 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1988 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1989 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1990 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1991 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1992 & fpid!=. & mpid==.
replace sosfoedselsaaryoung= foedselsaar[_n+1] if fpid==fpid[_n+1] & foedselsaar==1993 & fpid!=. & mpid==.

replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1986 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1987 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1988 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1989 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1990 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1991 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1992 & fpid!=. & mpid==.
replace sospidyoung= pid[_n+1] if fpid==fpid[_n+1] & foedselsaar==1993 & fpid!=. & mpid==.

order mpid fpid foedselsaar 

keep if foedselsaar>=1986 & foedselsaar<=1993

drop mpid fpid foedselsaar

* merge in grades to sospidold and sospidyoung

sort sospidold
save "/home1/katrine/temp.dta", replace


use "/data/utddta/grunnskar0209.dta"

sort pid
by pid: egen stpaver=mean(stp)

by pid: egen munaver=mean(mun)

by pid: egen skraver=mean(skr)

sort pid
drop if pid==pid[_n-1]

sort pid

keep pid stpaver  munaver skraver
rename stpaver stpaversosold
rename munaver munaversosold
rename skraver skraversosold
rename pid sospidold

merge sospidold using "/home1/katrine/temp.dta"
tab _merge
drop if _merge==1
drop _merge

sort sospidyoung
save "/home1/katrine/temp.dta", replace


use "/data/utddta/grunnskar0209.dta"

sort pid
by pid: egen stpaver=mean(stp)

by pid: egen munaver=mean(mun)

by pid: egen skraver=mean(skr)

sort pid
drop if pid==pid[_n-1]

sort pid

keep pid stpaver munaver skraver
rename stpaver stpaversosyoung
rename munaver munaversosyoung
rename skraver skraversosyoung
rename pid sospidyoung

merge sospidyoung using "/home1/katrine/temp.dta"
tab _merge
drop if _merge==1
drop _merge


sort pid 
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort pid
merge pid using "/home1/katrine/temp.dta"

drop _merge
order pid-sfaaryounger2 sospidyoung-sosfoedselsaaryoung
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

*14: hours of work
*a) mother  

set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep mpid
sort mpid
save "/home1/katrine/temp.dta", replace


local i = 1986
   while `i' <=2007{
use "/data/regdta/adssb`i'.dta"
keep pid hrs
rename pid mpid
rename hrs hrs`i'
sort mpid
merge mpid using "/home1/katrine/temp.dta"


tab _merge

drop if _merge==1
drop _merge
sort mpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

sort mpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort mpid
merge mpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace


*b) father  

set more off
use "/home/katrine/ccsubsidies/20111304_age5max.dta"
save "/home1/katrine/temp.dta", replace
keep fpid
sort fpid
save "/home1/katrine/temp.dta", replace


local i = 1986
   while `i' <=2007{
use "/data/regdta/adssb`i'.dta"
keep pid hrs
rename pid fpid
rename hrs fhrs`i'
sort fpid
merge fpid using "/home1/katrine/temp.dta"


tab _merge

drop if _merge==1
drop _merge
sort fpid
save "/home1/katrine/temp.dta", replace

local i = `i' + 1
   }

sort fpid
save "/home1/katrine/temp.dta", replace

use "/home/katrine/ccsubsidies/20111304_age5max.dta"
sort fpid
merge fpid using "/home1/katrine/temp.dta"

drop _merge
save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace

order pid-mage2006 hrs1986 hrs1987 hrs1988 hrs1989 hrs1990 hrs1991 hrs1992 hrs1993 hrs1994 hrs1995 hrs1996 hrs1997 hrs1998 hrs1999 hrs2000 hrs2001 hrs2002 hrs2003 hrs2004 hrs2005 hrs2006 hrs2007
order pid-mstat1993 mstat1994 mstat1995 mstat1996 mstat1997 mstat1998 mstat1999 mstat2000 mstat2001 mstat2002 mstat2006 mage1986-hrs2007 fpid-fage2006 fhrs1986 fhrs1987 fhrs1988 fhrs1989 fhrs1990 fhrs1991 fhrs1992 fhrs1993 fhrs1994 fhrs1995 fhrs1996 fhrs1997 fhrs1998 fhrs1999 fhrs2000 fhrs2001 fhrs2002 fhrs2003 fhrs2004 fhrs2005 fhrs2006
order pid-fhrs2006 fhrs2007 mothermissingincallyears-mfamt1993 mfamt1994 mfamt1995 mfamt1996 mfamt1997 mfamt1998 mfamt1999 mfamt2000 mfamt2001 mfamt2002

save "/home/katrine/ccsubsidies/20111304_age5max.dta", replace
