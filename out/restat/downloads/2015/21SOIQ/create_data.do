clear

set more off

set mem 5000m 
set matsize 500 

duplicates drop

gen b_year=substr(fodtaar,1,4)
gen b_month=substr(fodtaar, 5,2)
gen b_day=substr(fodtaar,7,2)
*change to ellapse date format
gen efodtaar=date(fodtaar,"YMD")
format efodtaar %td
drop fodtaar
rename efodtaar fodtaar

destring, replace force

*drop if both mother and father's id is missing (0)
drop if mor_lnr==0 & far_lnr==0



*keep 1986-1995 cohorts
keep if b_year>1985 & b_year<1996

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace

clear

*b.: grades

des using "/ssb/ovibos/a1/swp/data/wk48/nudb/score_gsk_g2001g2002.dta"



foreach y in g2001g2002 g2002g2003 g2003g2004 g2004g2005 g2005g2006 g2006g2007 g2007g2008 g2008g2009 {

clear

use lnr mun skr stp using "/ssb/ovibos/a1/swp/data/wk48/nudb/score_gsk_`y'.dta

destring, replace force
duplicates drop
drop if lnr==0

bys lnr: egen stpaver=mean(stp)
bys lnr: egen munaver=mean(mun)
bys lnr: egen skraver=mean(skr)


sort lnr
drop if lnr==lnr[_n-1]
keep lnr stpaver munaver skraver
sort lnr
merge m:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

drop if _merge==1
drop _merge

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace

}



clear

*c. parental income 1984/2007.


foreach i in mor far {
clear
use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta
sort `i'_lnr 

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace

clear

use "/ssb/ovibos/a1/swp/data/wk48/inntlonn/skattefil_g1967g2010.dta"
keep p_innt_1984 p_innt_1985 p_innt_1986 p_innt_1987 p_innt_1988 p_innt_1989 p_innt_1990 p_innt_1991 p_innt_1992 p_innt_1993 p_innt_1994 p_innt_1995 p_innt_1996 p_innt_1997 p_innt_1998 p_innt_1999 p_innt_2000 p_innt_2001 p_innt_2002 p_innt_2003 p_innt_2004 p_innt_2005 p_innt_2006 p_innt_2007 lnr
rename lnr `i'_lnr

destring, replace force

duplicates drop
drop if `i'_lnr ==0

forvalues t=1984/2007 {
rename p_innt_`t' `i'_inc`t'

}

sort `i'_lnr

merge 1:m `i'_lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

drop if _merge==1
drop _merge

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace

}



clear


*child education, 2006-2011 

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace
sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace


forvalues t=2006/2011 {

clear

use lnr bu_nus2000 using /ssb/ovibos/a1/swp/data/wk48/nudb/bu_g`t’.dta

rename bu_nus2000 nus2000_`t’_lnr

destring, replace force

drop if lnr==0
duplicates drop
sort lnr

bys lnr: gen n=_n
by lnr: gen N=_N
tab N
drop if N>1
drop n N
sort lnr

merge 1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta
drop if _merge==1
drop _merge
sort lnr 

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta, replace

}


clear

*f: mothers and fathers highest edu, citizenship,mstat and age 1985-2008


foreach c in mor far {

clear

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

sort `c'_lnr


save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta, replace


forvalues t=1985/2008 {


clear

use lnr bu_nus2000 alder statborg using /ssb/ovibos/a1/swp/data/wk48/nudb/bu_g`t'.dta


destring, replace force
drop if lnr==0
bys lnr: gen n=_n
bys lnr: gen N=_N
tab N
drop if N>1
drop n N

rename lnr `c'_lnr
rename bu_nus2000 `c'_nus2000_`t'
rename alder `c'_alder_`t'
rename statborg `c'_statborg_`t'

sort `c'_lnr

merge 1:m `c'_lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

drop if _merge==1

drop _merge

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace



}
}



clear



use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

sort mor_lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta, replace

clear

forvalues t=1985/2006 {
clear
use lnr sivilstand ekt_lnr using "/ssb/ovibos/a1/swp/data/wk48/befreg/bosatte_g`t'm01d01_persfil.dta"

destring, replace force
duplicates drop
drop if lnr==0

rename lnr mor_lnr
rename sivilstand sivilstand_`t'
rename ekt_lnr ekt_lnr_`t'
sort mor_lnr

merge 1:m mor_lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta
drop if _merge==1
drop _merge

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta, replace

}

forvalues t=2007/2008 {
clear
use lnr sivilstand ekt_lnr using "/ssb/ovibos/a1/swp/data/wk48/befreg/bosatte_g`t'm01d01.dta"

destring, replace force
duplicates drop
drop if lnr==0

rename lnr mor_lnr
rename sivilstand sivilstand_`t'
rename ekt_lnr ekt_lnr_`t'
sort mor_lnr

merge 1:m mor_lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta
drop if _merge==1
drop _merge

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta, replace

}


clear



*l: number of siblings within 14 yrs after the reform: totalt antall sosken. 



forvalues t=1986/1993 {

clear

local a=`t'+14

use  fodtaar lnr mor_lnr far_lnr kjonn using "/ssb/ovibos/a1/swp/data/wk48/befreg/alle_slektsfil_g1967g2006.dta"
drop if lnr=="0"
duplicates drop
gen b_year=substr(fodtaar,1,4)
gen b_month=substr(fodtaar, 5,2)
gen b_day=substr(fodtaar,7,2)

*change to ellapse date format
gen efodtaar=date(fodtaar,"YMD")
format efodtaar %td
drop fodtaar
rename efodtaar fodtaar

destring, replace force

*drop if both mother and father's id is missing (0)
drop if mor_lnr==0 & far_lnr==0

sort mor_lnr fodtaar

drop if ((mor_lnr == mor_lnr [_n-1] & b_year [_n-1]== `t')|( mor_lnr == mor_lnr [_n-2] & b_year [_n-2]== `t')|( mor_lnr == mor_lnr [_n-3] & b_year [_n-3]== `t')|( mor_lnr == mor_lnr [_n-4] & b_year [_n-4]== `t')|( mor_lnr == mor_lnr [_n-5] & b_year [_n-5]== `t')|( mor_lnr == mor_lnr [_n-6] & b_year [_n-6]== `t')|( mor_lnr == mor_lnr [_n-7] & b_year [_n-7]== `t')|( mor_lnr == mor_lnr [_n-8] & b_year [_n-8]== `t')|( mor_lnr == mor_lnr [_n-9] & b_year [_n-9]== `t')|( mor_lnr == mor_lnr [_n-10] & b_year [_n-10]== `t')|( mor_lnr == mor_lnr [_n-11] & b_year [_n-11]== `t')|( mor_lnr == mor_lnr [_n-12] & b_year [_n-12]== `t')|( mor_lnr == mor_lnr [_n-13] & b_year [_n-13]== `t')|( mor_lnr == mor_lnr [_n-14] & b_year [_n-14]== `t')|( mor_lnr == mor_lnr [_n-15] & b_year [_n-15]== `t')|( mor_lnr == mor_lnr [_n-16] & b_year [_n-16]== `t')|( mor_lnr == mor_lnr [_n-17] & b_year [_n-17]== `t')) & b_year>`a' & mor_lnr!=0



sort far_lnr fodtaar
 drop if ((far_lnr == far_lnr [_n-1] & b_year [_n-1]== `t')|( far_lnr == far_lnr [_n-2] & b_year [_n-2]== `t')|( far_lnr == far_lnr [_n-3] & b_year [_n-3]== `t')|( far_lnr == far_lnr [_n-4] & b_year [_n-4]== `t')|( far_lnr == far_lnr [_n-5] & b_year [_n-5]== `t')|( far_lnr == far_lnr [_n-6] & b_year [_n-6]== `t')|( far_lnr == far_lnr [_n-7] & b_year [_n-7]== `t')|( far_lnr == far_lnr [_n-8] & b_year [_n-8]== `t')|( far_lnr == far_lnr [_n-9] & b_year [_n-9]== `t')|( far_lnr == far_lnr [_n-10] & b_year [_n-10]== `t')|( far_lnr == far_lnr [_n-11] & b_year [_n-11]== `t')|( far_lnr == far_lnr [_n-12] & b_year [_n-12]== `t')|( far_lnr == far_lnr [_n-13] & b_year [_n-13]== `t')|( far_lnr == far_lnr [_n-14] & b_year [_n-14]== `t')|( far_lnr == far_lnr [_n-15] & b_year [_n-15]== `t')|( far_lnr == far_lnr [_n-16] & b_year [_n-16]== `t')|( far_lnr == far_lnr [_n-17] & b_year [_n-17]== `t')) & b_year>`a' & mor_lnr==0


sort mor_lnr fodtaar
bys mor_lnr: gen n=_n if mor_lnr!=0
bys mor_lnr: gen N=_N if mor_lnr!=0

gen sosken14=N-1 if N>1 & mor_lnr!=0
replace sosken14=0 if N==1 &  mor_lnr!=0

drop n N
sort far_lnr fodtaar
bys far_lnr: gen n=_n if mor_lnr==0
bys far_lnr: gen N=_N if mor_lnr==0

replace sosken14=N-1 if N>1 & mor_lnr==0
replace sosken14=0 if N==1 & mor_lnr==0

drop n N

keep if b_year==`t'

keep lnr sosken14

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/temp_`t'cohort.dta,replace


}



forvalues t=1986/1993 {

clear

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/temp_`t'cohort.dta


sort lnr

merge  1:1 lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

drop if _merge==1
drop _merge

sort lnr
save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta,replace
}



forvalues t=1986/1993 {

erase /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/temp_`t'cohort.dta

}


clear


use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta







******create variables

*gen edu at birth

foreach c in mor far {
gen  `c'_nus2000_birth=.

forvalues t=1986/1995 {
replace  `c'_nus2000_birth=`c'_nus2000_`t' if b_year==`t'

}
}

foreach c in mor far {
gen string_nus2000_`c'=string(`c'_nus2000_birth)
gen nivaa=substr(string_nus2000_`c', 1,1)
destring nivaa, gen(nivaa_n)
drop nivaa
rename nivaa_n nivaa
gen `c'_coll=1 if nivaa>=6 & nivaa<9
replace `c'_coll=0 if nivaa<6 & nivaa>0

gen `c'_HSC=1 if nivaa>=4 & nivaa<=5
replace `c'_HSC=0 if nivaa<4 & nivaa>0 | nivaa>5 & nivaa<9

gen `c'_dropout=1 if nivaa<=3 & nivaa>0
replace `c'_dropout=0 if nivaa>3 & nivaa<9


drop nivaa 
drop string_nus2000_`c'

}




gen str4 st_mor_nus2000_birth= string(mor_nus2000_birth)
gen str4 st_far_nus2000_birth= string(far_nus2000_birth)


*use standard classification and make nus-codes in to years of education

foreach c in mor far {
gen `c'_eduy_birth=.


replace `c'_eduy_birth=0 if substr(st_`c'_nus2000_birth,1,1)=="0"
replace `c'_eduy_birth=6 if substr(st_`c'_nus2000_birth,1,1)=="1"
replace `c'_eduy_birth=9 if substr(st_`c'_nus2000_birth,1,1)=="2"
replace `c'_eduy_birth=10 if substr(st_`c'_nus2000_birth,1,1)=="3"
replace `c'_eduy_birth=12 if substr(st_`c'_nus2000_birth,1,1)=="4"
replace `c'_eduy_birth=13 if substr(st_`c'_nus2000_birth,1,1)=="5"
replace `c'_eduy_birth=15 if substr(st_`c'_nus2000_birth,1,1)=="6"
replace `c'_eduy_birth=17 if substr(st_`c'_nus2000_birth,1,1)=="7"
replace `c'_eduy_birth=21 if substr(st_`c'_nus2000_birth,1,1)=="8"
 }





/*married to childs father year before reforms:antar at dersom gift er de gift med far til barnet. ekt_lnr er mangefull variabel
*/

gen marcfyb=.

forvalues t=1986/1995 {

local a=`t'-1

replace marcfyb=1 if sivilstand_`a'==2 & b_year==`t'
replace marcfyb=0 if marcfyb==. & sivilstand_`a'!=. &  b_year==`t'

}


*married to childs father 14 years after reforms

gen marrchf14=.

forvalues t=1986/1993 {

local i=`t'+14

replace marrchf14=1 if sivilstand_`i'==2 & b_year==`t'
replace marrchf14=0 if marrchf14==. & sivilstand_`i'!=. & b_year==`t'
}


*High school dropout, evalueate at age 20:  

forvalues t=2006/2011 {
gen string_nus2000_`t'_lnr=string(nus2000_`t'_lnr)
gen nivaa`t'=substr(string_nus2000_`t'_lnr, 1,1)
destring nivaa`t', gen(nivaa_n)
drop nivaa`t'
rename nivaa_n nivaa`t'

}

gen dropout=.

forvalues t=1986/1991 {

local i=`t'+20

replace dropout=1 if nivaa`i’< 9 & b_year==`t' /*9=missing*/

replace dropout=0 if nivaa`i’>=4 & nivaa`i’<9 & b_year==`t'

}



*age and citezenship at birth

gen mageb=.
gen fageb=.
gen mstatborgb=.
gen fstatborgb=.

forvalues t=1986/1995 {

replace mageb=mor_alder_`t' if b_year==`t'
replace fageb=far_alder_`t' if b_year==`t'
replace mstatborgb=mor_statborg_`t' if b_year==`t'
replace fstatborgb=far_statborg_`t' if b_year==`t'
}





*dummies
gen mage28=1 if mageb>28 & mageb!=.
gen fage28=1 if fage>28 & fageb!=.
replace mage28=0 if  mageb<=28 & mageb!=.
replace fage28=0 if fageb<=28 & fageb!=.



*number of children 14 years after reform:
gen nchild14=sosken14+1


/**fam income,min, finc. fam inc is missing if both mother and father's income is missing.ow. set missing=0 and add income*/


forvalues t=1984/2007 {

gen finc`t'= far_inc`t'
gen minc`t'=mor_inc`t'

replace finc`t'=0 if  finc`t'==. & minc`t'!=.
replace minc`t'=0 if  finc`t'!=. & minc`t'==.

gen faminc`t'=finc`t'+ minc`t'

}



gen g1985=25333
gen g1986=27433
gen g1987=29267
gen g1988=30850
gen g1989=32272
gen g1990=33575
gen g1991=35033
gen g1992=36167
gen g1993=37033
gen g1994=37820
gen g1995=38847
gen g1996=40410
gen g1997=42000
gen g1998=44413
gen g1999=46423
gen g2000=48377
gen g2001=50603
gen g2002=53233
gen g2003=55964
gen g2004=58139
gen g2005=60059
gen g2006=62161
gen g2007=65055


*define eligibility

forvalues t=1986/1995 {

local a=`t'-1

gen eligible`t'=1 if mor_inc`a'>g`a' & mor_inc`a'!=. & b_year==`t'
replace eligible`t'=0 if eligible`t'==. & b_year==`t'

}



*yrs employed total

forvalues t=1/14 {

gen mor_emp`t'=.
gen far_emp`t'=.

}


forvalues t=1986/1993 {
forvalues i=1/14 {

local a=`t'+`i'

replace mor_emp`i'=1 if mor_inc`a'>g`a' & mor_inc`a'!=. & b_year==`t'
replace mor_emp`i'=0 if  minc`a'<=g`a' & b_year==`t'
replace mor_emp`i'=0 if mor_emp`i'==. & b_year==`t'

replace far_emp`i'=1 if far_inc`a'>g`a' & far_inc`a'!=. & b_year==`t'
replace far_emp`i'=0 if  far_inc`a'<=g`a' & b_year==`t'
replace far_emp`i'=0 if far_emp`i'==. & b_year==`t'


}
}




***unpaid leave: 36 months.: 




forvalues t=1986/1993 {

local i=`t'-1
local a=`t'+1
local b=`t'+2
local c=`t'+3

*unpaid leave first 12 months:
gen mlup`t'=(1-((((((12-b_month+1)/12)*minc`t')+minc`a')/((24-b_month+1)/12))/(minc`i')))*12 if eligible`t'==1 
replace mlup`t'=0 if mlup`t'<0 & eligible`t'==1 

*unpaid leave next 12 months:

gen ml`t'_1=(1-((minc`a'+minc`b')/(2*(minc`i'))))*12 if eligible`t'==1 
replace ml`t'_1=0 if ml`t'_1<0 & eligible`t'==1 
replace mlup`t'=12+ ml`t'_1 if mlup`t'==12



*unpaid leave next 12 months:

gen ml`t'_2=(1-((minc`b'+minc`c')/(2*(minc`i'))))*12 if eligible`t'==1 
replace ml`t'_2=0 if ml`t'_2<0 & eligible`t'==1 
replace mlup`t'=24+ ml`t'_2 if mlup`t'==24

table b_month if eligible`t'== 1 & b_year== `t', row col c(m mlup`t')
drop ml`t'_1 ml`t'_2


}


gen mluptot=.

forvalues t=1986/1993 {

replace mluptot=mlup`t' if b_year==`t'

}

***add total leave

gen totleave=mluptot+4.5 if b_year==1986
replace totleave=mluptot+4.5 if b_year==1987 & b_month<5
replace totleave=mluptot+5 if b_year==1987 & b_month>=5
replace totleave=mluptot+5 if b_year==1988 & b_month<7
replace totleave=mluptot+5.5 if b_year==1988 & b_month>=7
replace totleave=mluptot+5.5 if b_year==1989 & b_month <4
replace totleave=mluptot+6 if b_year==1989 & b_month >=4
replace totleave=mluptot+6 if b_year==1990 & b_month <5
replace totleave=mluptot+7 if b_year==1990 & b_month >=5
replace totleave=mluptot+7 if b_year==1991 & b_month <7
replace totleave=mluptot+8 if b_year==1991 & b_month >=7
replace totleave=mluptot+8 if b_year==1992 & b_month <4
replace totleave=mluptot+8.75 if b_year==1992 & b_month >=4
replace totleave=mluptot+8.75 if b_year==1993 & b_month <4
replace totleave=mluptot+9.5 if b_year==1993 & b_month >=4

sort lnr

save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta, replace


forvalues t=1986/1993 {
table b_month if eligible`t'==1&b_year==`t',row col c(m totleave)
}



***COSTS****

******create direct costs: 
/*
We need to assume full take-up if eligible as we don't have actual take-up for most of them.
Use income year before birth as basis. if they earned more than 6G have to cap it at this.

*/


*gen inc year before birth
use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_86_95.dta

gen minc_base=.

forvalues t=1986/1995 {

local a=`t'-1

replace minc_base=mor_inc`a' if b_year==`t' & eligible`t'==1


}

*replace by 6G if base is above 6G

forvalues t=1986/1995 {

replace minc_base=6*g`t' if b_year==`t' & minc_base>6*g`t' & minc_base!=. & eligible`t'==1

}

*gen monthly level of base

gen minc_base_month=minc_base/12


gen cost_direct=4.5*minc_base_month if b_year==1986
replace cost_direct=4.5*minc_base_month if b_year==1987 & b_month<5
replace cost_direct=5*minc_base_month if b_year==1987 & b_month>=5
replace cost_direct=5*minc_base_month if b_year==1988 & b_month<7
replace cost_direct=5.5*minc_base_month if b_year==1988 & b_month>=7
replace cost_direct=5.5*minc_base_month if b_year==1989 & b_month<4
replace cost_direct=6*minc_base_month if b_year==1989 & b_month>=4
replace cost_direct=6*minc_base_month if b_year==1990 & b_month<5
replace cost_direct=7*minc_base_month if b_year==1990 & b_month>=5
replace cost_direct=7*minc_base_month if b_year==1991 & b_month<7
replace cost_direct=8*minc_base_month if b_year==1991 & b_month>=7
replace cost_direct=8*minc_base_month if b_year==1992 & b_month<4
replace cost_direct=8.75*minc_base_month if b_year==1992 & b_month>=4
replace cost_direct=8.75*minc_base_month if b_year==1993 & b_month<4
replace cost_direct=9.5*minc_base_month if b_year==1993 & b_month>=4


save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost.dta, replace




forvalues t=1986/1993 {

replace cost_direct=cost_direct*(kpi2010/kpi`t') if b_year==`t'
}

replace cost_direct=cost_direct/6


save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost.dta, replace


forvalues t=1986/2010 {

foreach c in mor far {

clear

use "/ssb/ovibos/h1/kvs/wk24/income/disp_g`t'.dta"
destring, replace force


*Skattefrie overf¯ringer: summen av barnetrygd, engangsst¯nad og Fors¯rgerst¯nad/fors¯rgerfradrag + pensjon

gen skattfrie_overf`t'=mat_pay+ch_allow+fam_allow+benefits

*skatt: iskatt er faktisk skatt betalt av pensjons givende inntekt
gen skatt`t'=iskatt
gen lonn`t'=lonn


keep lnr skattfrie_overf`t' skatt`t' lonn`t'



rename lnr `c'_lnr
rename skatt`t' `c'_skatt`t'
rename skattfrie_overf`t' `c'_skattfrie_overf`t'
rename lonn`t' `c'_lonn`t'

merge 1:m `c'_lnr using /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost.dta
drop if _merge==1
drop _merge


save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost.dta, replace
}


}







/*gen paa fam-nivaa: merk de med missing blir kodet som 0. de vil vÊrt registrert

 med en positiv sum dersom de hadde mottatt st¯tte og betalt skatt etc.*/

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost.dta, clear

forvalues t=1986/2010 {

replace mor_skatt`t'=0 if mor_skatt`t'==. 
replace far_skatt`t'=0 if far_skatt`t'==. 

replace mor_skattfrie_overf`t'=0 if mor_skattfrie_overf`t'==. 
replace far_skattfrie_overf`t'=0 if far_skattfrie_overf`t'==. 


replace mor_lonn`t'=0 if mor_lonn`t'==. 
replace far_lonn`t'=0 if far_lonn`t'==. 


}

forvalues t=1986/2010 {

gen skatt`t'=mor_skatt`t'+far_skatt`t'
gen skattfrie_overf`t'=mor_skattfrie_overf`t'+far_skattfrie_overf`t'


}




*disposable income

forvalues t=1986/2010 {

gen famlonn`t'=mor_lonn`t'+far_lonn`t'

} 

forvalues t=1987/2010 {
gen disp_faminc`t'=famlonn`t'+skattfrie_overf`t'-skatt`t'

}








forvalues t=1986/2010 {
replace disp_faminc`t'=0 if disp_faminc`t'<0

}


*kpi juster: 2010 NOK.
gen kpi1985=61.9
gen kpi1986=66.3
gen kpi1987=72.1	
gen kpi1988=76.9	
gen kpi1989=80.4	
gen kpi1990=83.7	
gen kpi1991=86.6	
gen kpi1992=88.6	
gen kpi1993=90.6	
gen kpi1994=91.9	
gen kpi1995=94.2	
gen kpi1996=95.3
gen kpi1997=97.8	
gen kpi1998=100	
gen kpi1999=102.3	
gen kpi2000=105.5	
gen kpi2001=108.7	
gen kpi2002=110.1	
gen kpi2003=112.8	
gen kpi2004=113.3	
gen kpi2005=115.1	
gen kpi2006=117.7	
gen kpi2007=118.6
gen kpi2010=128.8


forvalues t=1986/2009 {

replace disp_faminc`t'=disp_faminc`t'*(kpi2010/kpi`t')
replace skatt`t'=skatt`t'*(kpi2010/kpi`t')
replace famlonn`t'=famlonn`t'*(kpi2010/kpi`t')
replace skattfrie_overf`t'=skattfrie_overf`t'*(kpi2010/kpi`t')


}








save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost0.dta, replace


use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost0.dta, clear







***neddiskontert 0-14 Âr, diskontert med 1.023
gen annuity_disp_faminc=.
gen annuity_skatt=.
gen annuity_benefits=.



forvalues t=1987/2007 {

rename skattfrie_overf`t' benefits`t'


}

forvalues t=1987/1992 {

local a=`t'+1
local b=`t'+2
local c=`t'+3
local d=`t'+4
local e=`t'+5
local f=`t'+6
local g=`t'+7
local h=`t'+8
local i=`t'+9
local j=`t'+10
local k=`t'+11
local l=`t'+12
local m=`t'+13
local n=`t'+14

foreach w in disp_faminc skatt benefits{

replace annuity_`w'=(`w'`t'+(`w'`a'/1.023)+ (`w'`b'/(1.023^2))+ (`w'`c'/(1.023^3))+ (`w'`d'/(1.023^4))+ (`w'`e'/(1.023^5))+ (`w'`f'/(1.023^6))+ (`w'`g'/(1.023^7))+ (`w'`h'/(1.023^8))+ (`w'`i'/(1.023^9))+ (`w'`j'/(1.023^10))+ (`w'`k'/(1.023^11))+ (`w'`l'/(1.023^12))+ (`w'`m'/(1.023^13))+ (`w'`n'/(1.023^14)))*(0.023/(1.023*(1-(1.023)^(-15))))  if b_year==`t'



}
}



replace annuity_disp_faminc=annuity_disp_faminc/6
replace annuity_skatt=annuity_skatt/6
replace annuity_benefits=annuity_benefits/6

label var annuity_disp_faminc "annuity of fam. disposable income 0-14 after birth"
label var annuity_skatt "annuity of fam. taxes paid  0-14 years after birth"
label var annuity_benefits "annuity of non taxable fam. benefits received  0-14 years after birth"


gen net_cost=cost_direct+annuity_benefits-annuity_skatt



*yrs employed total 2-14 (max 13)



gen memptot=mor_emp2+mor_emp3+mor_emp4+mor_emp5+mor_emp6+mor_emp7+mor_emp8+mor_emp9+mor_emp10+mor_emp11+mor_emp12+mor_emp13+mor_emp14

gen femptot=far_emp2+ far_emp3+ far_emp4+ far_emp5+ far_emp6+ far_emp7+ far_emp8+ far_emp9+ far_emp10+ far_emp11+ far_emp12+ far_emp13+ far_emp14

drop mor_emp3-far_emp14




****annutity mother and father income 2-14 years

*kpi juster


forvalues t=1987/2007 {

replace finc`t'=finc`t'*(kpi2010/kpi`t')
replace minc`t'=minc`t'*(kpi2010/kpi`t')
replace faminc`t'=faminc`t'*(kpi2010/kpi`t')

}





*annuity income 2-14 yrs after reform.


gen minctot=.
gen finctot=.

forvalues t=1986/1993 {


local b=`t'+2
local c=`t'+3
local d=`t'+4
local e=`t'+5
local f=`t'+6
local g=`t'+7
local h=`t'+8
local i=`t'+9
local j=`t'+10
local k=`t'+11
local l=`t'+12
local m=`t'+13
local n=`t'+14

foreach w in f m {

replace `w'inctot=((`w'inc`b')+ (`w'inc`c'/(1.023))+ (`w'inc`d'/(1.023^2))+ (`w'inc`e'/(1.023^3))+ (`w'inc`f'/(1.023^4))+ (`w'inc`g'/(1.023^5))+ (`w'inc`h'/(1.023^6))+ (`w'inc`i'/(1.023^7))+ (`w'inc`j'/(1.023^8))+ (`w'inc`k'/(1.023^9))+ (`w'inc`l'/(1.023^10))+ (`w'inc`m'/(1.023^11))+ (`w'inc`n'/(1.023^12)))*(0.023/(1.023*(1-(1.023)^(-13)))) if b_year==`t'


}
}





*gender gap



gen ggemptot=memptot/(memptot+femptot)
replace ggemptot=0.5 if memptot==0 & femptot==0

gen gginctot=minctot/(minctot+finctot)
replace gginctot=0.5 if minctot==0 & finctot==0







***Want everything in US dollars. divide by 6:

gen minctot_d=minctot/6
gen finctot_d=finctot/6
drop minctot finctot
rename minctot_d minctot
rename finctot_d finctot





save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, replace

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear

/*
***create Extended disposable income: Same as the one above but add dollar value of child outcome "high school dropout.
	
2*: kontroller for f¯dselskohort + f¯dselskommune		
	
 */
 
*annuity in us dollars

gen ext2=28263.6/6



gen annuity_disp_faminc_ext2=annuity_disp_faminc if dropout_20==1
replace annuity_disp_faminc_ext2=annuity_disp_faminc+ext2 if dropout_20==0



save /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, replace








log close 

