// Reads ISSP 96 Data, recodes var., merges Skill Data from Rehm
// rev. 2  12/2/9
// mail@daniel-stegmueller.com

// code uses vreverse ado by Nick Cox (ssc install vreverse)


use "ZA2900_F1.dta",clear

sort v3 v2
merge v3 v2 using "SkillSpecificity1996.dta", unique
drop if _merge != 3
drop _merge
ren s_comp_lfs complfs

// Spending items
vreverse v31, gen(uempl)
vreverse v26, gen(health)
vreverse v30, gen(retire)

gen sumscore=uempl+health+retire //simple sumscore

// Covariates
recode v200 (1=0) (2=1) (.a=.),gen(female)
clonevar age=v201
recode v204 (97 94=0) (95 96 .a .b =.) , gen(eduyrs)
recode v205 (1 2 = 1) (.b=.),gen(educat)
vreverse v50,gen(informed)
recode v223 (6 7 .a .b =3),gen(lrpos)

// employment variables
gen pemploy=0
replace pemploy=1 if v206==2|v206==3
gen unemploy=0
replace unemploy = 1 if v206==5
gen noemploy=0
replace noemploy=1 if v206==4|v206==6|v206==7|v206==8|v206==9|v206==10
gen selfemploy=0
replace selfemploy=1 if v213==1

// Income
clonevar inc=v217
replace inc=150000 if inc>150000

//income country std.
foreach m of numlist 1 2 3 4 6 9 10 12 13 19 20 25 27 30 {
  egen inc_`m' = std(inc) if v3==`m'
  }
replace inc=.
foreach m of numlist 1 2 3 4 6 9 10 12 13 19 20 25 27 30 {
  replace inc = inc_`m' if v3==`m'
  }
drop inc_1- inc_30

clonevar cntry=v3
drop if cntry==9 //Italy 
drop if cntry==25 //Spain

// gen num. cntry code from 1 to 12
gen cntryn=.
local j = 1
foreach m of numlist 1 2 3 4 6 10 12 13 19 20 27 30 {
 replace cntryn=`j' if v3==`m'
 local j = `j' + 1
 }


keep s1_lfs - cntryn


// drop missing covariates
dropmiss female- inc,obs any force
dropmiss complfs,obs any force


/// draw 50 percent subsample
gen rand = uniform()
sort rand
gen lfd = _n
drop if lfd > 5987
drop lfd rand


/// switch to LONG format
sort cntry
gen id=_n
ren health y1
ren uempl y2
ren retire y3
reshape long y,i(id)
ren _j item

compress
save "data.dta"

