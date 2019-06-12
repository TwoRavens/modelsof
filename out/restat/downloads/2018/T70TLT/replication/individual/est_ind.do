*****************
*** read data ***
*****************

use "..\data\data_ind.dta", clear
set more off
log using est_ind, replace
set matsize 11000
set scheme s2mono
set seed 1234567

keep if percentile==100&move==1

global z_j i.origin i.birth i.firstwork i.workplace ln_dist1
global z_edu i.eduXj1 i.eduXj2 i.eduXj3 i.eduXj4 i.eduXj5 i.eduXj6 i.eduXj7 i.eduXj8 i.eduXj9 i.eduXj10 i.eduXj11 i.eduXj12 i.eduXj13 i.eduXj14 i.eduXj17
global z_age ageXj1 ageXj2 ageXj3 ageXj4 ageXj5 ageXj6 ageXj7 ageXj8 ageXj9 ageXj10 ageXj11 ageXj12 ageXj13 ageXj14 ageXj17
global z_age2 age2Xj1 age2Xj2 age2Xj3 age2Xj4 age2Xj5 age2Xj6 age2Xj7 age2Xj8 age2Xj9 age2Xj10 age2Xj11 age2Xj12 age2Xj13 age2Xj14 age2Xj17
global z_sex i.sexXj1 i.sexXj2 i.sexXj3 i.sexXj4 i.sexXj5 i.sexXj6 i.sexXj7 i.sexXj8 i.sexXj9 i.sexXj10 i.sexXj11 i.sexXj12 i.sexXj13 i.sexXj14 i.sexXj17

gen ln_net_mtrXpost = ln_net_mtr if year>2010
replace ln_net_mtrXpost = 0 if year<=2010
gen ln_net_atrXpost = ln_net_atr if year>2010
replace ln_net_atrXpost = 0 if year<=2010


********************
*** baseline LPM ***
********************

* baseline atr [table 2]

quietly: xi: xtivreg2 d ln_net_atrXpost i.jXyear, fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost i.jXyear, fe cluster(cluster_regionXyear id2) partial(i.jXyear) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 replace

quietly: xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear, fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear, fe cluster(cluster_regionXyear id2) partial(i.jXyear) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_edu  if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_edu  if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  ) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_age if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_age if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_age   ) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_age  $z_age2  if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_age  $z_age2  if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_age  $z_age2   ) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_sex  if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_sex  if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_sex   ) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex   if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_atrXpost $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex   if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2 $z_sex  ) 
outreg2  using "tab2",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3) nor2 append



* baseline ATR with IV [table 3]

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) i.jXyear,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) i.jXyear,  fe cluster(cluster_regionXyear id2) partial(i.jXyear)  savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) nor2 replace

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear,  fe cluster(cluster_regionXyear id2) partial(i.jXyear)  savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu ,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu ,  fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu )  savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_age  ,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_age  ,  fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_age  )  savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) append

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_age  $z_age2   ,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_age  $z_age2   ,  fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_age  $z_age2   )   savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_sex    ,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_sex  ,  fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_sex   )  savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) nor2 append

quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex     ,  fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
quietly: xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex   ,  fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2  $z_sex   )  savefirst
est sto IV
mat f = e(first)
local F_1st = f[4,1]
est restore _xtivreg2_ln_net_atrXpost
mat b = e(b)
local b_1st = b[1,1]
mat s = e(V)
local se_1st = sqrt(s[1,1])
est restore IV
outreg2  using "tab3",  adds(R2 w/o partialing out, `r2', First Stage Coeffcient , `b_1st', se ,`se_1st', F-statistic, `F_1st') stats(coef se) excel tex(frag) bdec(3) nor2 append

* MTR [table A9]

quietly:  xi: xtivreg2 d ln_net_mtrXpost i.jXyear, fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost i.jXyear, fe cluster(cluster_regionXyear id2) partial(i.jXyear)
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  replace

quietly: xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear, fe cluster(cluster_regionXyear id2)
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear, fe cluster(cluster_regionXyear id2) partial(i.jXyear)
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  append

quietly: xi: xtivreg2 d ln_net_mtrXpost $z_j  i.jXyear $z_edu if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost $z_j  i.jXyear $z_edu if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  )
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  append

quietly: xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_age if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_age if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_age   )
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  append

quietly:xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_age  $z_age2  if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_age  $z_age2  if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_age  $z_age2   )
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  append

quietly: xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_sex  if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_sex  if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_sex   )
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  append

quietly: xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex   if percentile==100 , fe cluster(cluster_regionXyear id2) 
local r2=round(e(r2),.001) 
xi: xtivreg2 d ln_net_mtrXpost $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex   if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2 $z_sex )
outreg2  using "tabA13",  adds(R2 w/o partialing out, `r2') stats(coef se) excel tex(frag) bdec(3)  nor2  append


* placebo [table 4]

* - the rhs is the average over the speci 2011-2014
* - the lhs is actual migration before 2011 (first estimation), and the previous sample (second estimation)

shell erase tab4`speci'.*

xi: xtivreg2 d ln_net_atr_mean1411 $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex    if move==1&year>2010&percentile==100, fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2  $z_sex   )
outreg2 using "tab4",  stats(coef se) excel tex(frag) bdec(3) nor2 replace

xi: xtivreg2 d ln_net_atr_mean1411 $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex  if move==1&year<=2010&percentile==100, fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2  $z_sex   )
outreg2 using "tab4",  stats(coef se) excel tex(frag) bdec(3) nor2 append

xi: xtivreg2 d (ln_net_atr_mean1411 = ln_net_mtr_mean1411 )  $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex    if move==1&year>2010&percentile==100, fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2 $z_sex   ) first
mat f = e(first)
local F_1st = f[4,1]
outreg2 using "tab4", addstat(F-statistic, `F_1st')   stats(coef se) excel tex(frag) bdec(3) nor2 append 

xi: xtivreg2 d (ln_net_atr_mean1411 = ln_net_mtr_mean1411) $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex    if move==1&year<=2010&percentile==100, fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age  $z_age2 $z_sex   ) first
mat f = e(first)
local F_1st = f[4,1]
outreg2 using "tab4", addstat(F-statistic, `F_1st')    stats(coef se) excel tex(frag) bdec(3) nor2 append



****************************
*** heterogenous effects ***
****************************


* - models present directly coefficnets for the different groups and a test for equality below
* - tables also include the # obs in the first group


* age (younger than 40 vs. older)


gen age_young=1 if age<40
replace age_young=0 if age_young==.

gen ln_net_mtrXint1=ln_net_mtrXpost*age_young 
gen ln_net_mtrXint0=ln_net_mtrXpost*(1-age_young) 

gen ln_net_atrXint1=ln_net_atrXpost*age_young 
gen ln_net_atrXint0=ln_net_atrXpost*(1-age_young)


sum age_young if age_young==0 &j==1
local n_first=r(N)

xi: xtivreg2 d (ln_net_atrXint1 ln_net_atrXint0 = ln_net_mtrXint1 ln_net_mtrXint0  ) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex    if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex  ) first
mat f = e(first)
local F_1st = f[4,1]


test ln_net_atrXint0 = ln_net_atrXint1
local p= r(p)
local F= r(F)

outreg2  using "tabA15",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first', F-statistic, `F_1st') excel tex(frag) bdec(3) replace

drop ln_net_mtrXint* ln_net_atrXint*

* kids > 0

gen kids=0
replace kids=1 if pers_kids_total>0

gen ln_net_mtrXint1=ln_net_mtrXpost*kids
gen ln_net_mtrXint0=ln_net_mtrXpost*(1-kids) 

gen ln_net_atrXint1=ln_net_atrXpost*kids 
gen ln_net_atrXint0=ln_net_atrXpost*(1-kids)

sum kids if kids==0 &j==1
local n_first=r(N)

xi: xtivreg2 d (ln_net_atrXint1 ln_net_atrXint0 = ln_net_mtrXint1 ln_net_mtrXint0  ) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex    if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex   ) first
mat f = e(first)
local F_1st = f[4,1]


test ln_net_atrXint0 = ln_net_atrXint1
local p= r(p)
local F= r(F)

outreg2  using "tabA15",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first', F-statistic, `F_1st') excel tex(frag) bdec(3) append

drop ln_net_mtrXint* ln_net_atrXint*


* gender

gen male=1 if sex==1
replace male=0 if male==.

gen ln_net_mtrXint1=ln_net_mtrXpost*male
gen ln_net_mtrXint0=ln_net_mtrXpost*(1-male) 

gen ln_net_atrXint1=ln_net_atrXpost*male 
gen ln_net_atrXint0=ln_net_atrXpost*(1-male)

sum sex if sex==1 &j==1
local n_first=r(N)

xi: xtivreg2 d (ln_net_atrXint1 ln_net_atrXint0 = ln_net_mtrXint1 ln_net_mtrXint0  ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex  ) first
mat f = e(first)
local F_1st = f[4,1]


test ln_net_atrXint0 = ln_net_atrXint1
local p= r(p)
local F= r(F)


outreg2  using "tabA15",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first' , F-statistic, `F_1st') excel tex(frag) bdec(3) append

drop ln_net_mtrXint* ln_net_atrXint*


* education

gen ln_net_mtrXint1=ln_net_mtrXpost*edu_uni
gen ln_net_mtrXint0=ln_net_mtrXpost*(1-edu_uni) 

gen ln_net_atrXint1=ln_net_atrXpost*edu_uni 
gen ln_net_atrXint0=ln_net_atrXpost*(1-edu_uni)

sum edu_uni if edu_uni==1 &j==1
local n_first=r(N)

xi: xtivreg2 d (ln_net_atrXint1 ln_net_atrXint0 = ln_net_mtrXint1 ln_net_mtrXint0  ) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex    if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex  ) first
mat f = e(first)
local F_1st = f[4,1]

test ln_net_atrXint0 = ln_net_atrXint1
local p= r(p)
local F= r(F)

outreg2  using "tabA15",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first' , F-statistic, `F_1st') excel tex(frag) bdec(3) append

drop ln_net_mtrXint* ln_net_atrXint*



* work relation / sector [table A15] 

*fired in t-1

gen fired_t1=0
replace fired_t1=1 if reason_dismissal_lag==54


gen ln_net_mtr_fired_t1=ln_net_mtrXpost if reason_dismissal_lag==54
replace ln_net_mtr_fired_t1=0 if ln_net_mtr_fired_t1==.
gen ln_net_atr_fired_t1=ln_net_atrXpost if reason_dismissal_lag==54
replace ln_net_atr_fired_t1=0 if ln_net_atr_fired_t1==.

gen ln_net_mtr_notfired_t1=ln_net_mtrXpost if reason_dismissal_lag~=54
replace ln_net_mtr_notfired_t1=0 if ln_net_mtr_notfired_t1==.
gen ln_net_atr_notfired_t1=ln_net_atrXpost if reason_dismissal_lag~=54
replace ln_net_atr_notfired_t1=0 if ln_net_atr_notfired_t1==.


xi: xtivreg2 d ( ln_net_atr_notfired_t1 ln_net_atr_fired_t1 = ln_net_mtr_fired_t1 ln_net_mtr_notfired_t1 ) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex) first
mat f = e(first)
local F_1st = f[4,1]

test ln_net_atr_fired_t1 = ln_net_atr_notfired_t1 
local p= r(p)
local F= r(F)


sum fired_t1 if fired_t1==0&j==1
local n_first=r(N)

sum fired_t1 if fired_t1==1&j==1
local n_second=r(N)

outreg2  using "tabA16",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first',  obs (second group), `n_second' , F-statistic, `F_1st') excel tex(frag) bdec(3) replace


*fired in t

gen fired_t=0
replace fired_t=1 if reason_dismissal==54


gen ln_net_mtr_fired_t=ln_net_mtrXpost if reason_dismissal==54
replace ln_net_mtr_fired_t=0 if ln_net_mtr_fired_t==.
gen ln_net_atr_fired_t=ln_net_atrXpost if reason_dismissal==54
replace ln_net_atr_fired_t=0 if ln_net_atr_fired_t==.

gen ln_net_mtr_notfired_t=ln_net_mtrXpost if reason_dismissal~=54
replace ln_net_mtr_notfired_t=0 if ln_net_mtr_notfired_t==.
gen ln_net_atr_notfired_t=ln_net_atrXpost if reason_dismissal~=54
replace ln_net_atr_notfired_t=0 if ln_net_atr_notfired_t==.


xi: xtivreg2 d ( ln_net_atr_notfired_t ln_net_atr_fired_t = ln_net_mtr_fired_t ln_net_mtr_notfired_t ) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex ) first
mat f = e(first)
local F_1st = f[4,1]

test ln_net_atr_fired_t = ln_net_atr_notfired_t 
local p= r(p)
local F= r(F)


sum fired_t if fired_t==0&j==1
local n_first=r(N)

sum fired_t if fired_t==1&j==1
local n_second=r(N)

outreg2  using "tabA16",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first',  obs (second group), `n_second' , F-statistic, `F_1st') excel tex(frag) bdec(3) append




* change firm location

gen change_firm_location=0
replace change_firm_location=1 if firm_main_prov~=firm_main_prov_lag & (firm_id_main_lag == firm_id_main | firm_id_tax_lag == firm_id_tax)

gen ln_net_mtr_change=ln_net_mtrXpost if change_firm_location==1
replace ln_net_mtr_change=0 if ln_net_mtr_change==.
gen ln_net_atr_change=ln_net_atrXpost  if change_firm_location==1
replace  ln_net_atr_change=0 if ln_net_atr_change==.

gen ln_net_mtr_nochange=ln_net_mtrXpost if change_firm_location==0
replace ln_net_mtr_nochange=0 if ln_net_mtr_nochange==.
gen ln_net_atr_nochange=ln_net_atrXpost  if change_firm_location==0
replace  ln_net_atr_nochange=0 if ln_net_atr_nochange==.


xi: xtivreg2 d ( ln_net_atr_nochange ln_net_atr_change  = ln_net_mtr_nochange ln_net_mtr_change  ) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex) first
mat f = e(first)
local F_1st = f[4,1]

test ln_net_atr_change = ln_net_atr_nochange
local p= r(p)
local F= r(F)


sum change_firm_location if change_firm_location==0&j==1
local n_first=r(N)

sum change_firm_location if change_firm_location==1&j==1
local n_second=r(N)

outreg2  using "tabA16",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first',  obs (second group), `n_second', F-statistic, `F_1st') excel tex(frag) bdec(3) append


* change firm id

gen change_firm_contract=1  if (firm_id_main_lag ~= firm_id_main & firm_id_tax_lag ~= firm_id_tax)
replace change_firm_contract =0 if change_firm_contract==.

gen ln_net_mtr_change2=ln_net_mtrXpost if change_firm_contract==1
replace ln_net_mtr_change2=0 if ln_net_mtr_change2==.
gen ln_net_atr_change2=ln_net_atrXpost  if change_firm_contract==1
replace  ln_net_atr_change2=0 if ln_net_atr_change2==.

gen ln_net_mtr_nochange2=ln_net_mtrXpost if change_firm_contract==0
replace ln_net_mtr_nochange2=0 if ln_net_mtr_nochange2==.
gen ln_net_atr_nochange2=ln_net_atrXpost  if change_firm_contract==0
replace  ln_net_atr_nochange2=0 if ln_net_atr_nochange2==.


xi: xtivreg2 d ( ln_net_atr_nochange2 ln_net_atr_change2  = ln_net_mtr_nochange2 ln_net_mtr_change2  ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex  if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex) first
mat f = e(first)
local F_1st = f[4,1]

test ln_net_atr_change2 = ln_net_atr_nochange2
local p= r(p)
local F= r(F)


sum change_firm_contract if change_firm_contract==0&j==1
local n_first=r(N)

sum change_firm_contract if change_firm_contract==1&j==1
local n_second=r(N)

outreg2  using "tabA16",  stats(coef se) addstat(p-value,`p', obs (first group), `n_first',  obs (second group), `n_second', F-statistic, `F_1st') excel tex(frag) bdec(3) append



* ocupation [table A20]

replace occu_cat=4 if occu_cat==999
replace occu_cat=4 if occu_cat==888



shell erase tabA20*



foreach occu of numlist  1 2 3 4  {



gen ln_net_mtrX`occu'_1=ln_net_mtrXpost if occu_cat==`occu'
replace ln_net_mtrX`occu'_1=0 if ln_net_mtrX`occu'_1==.
gen ln_net_mtrX`occu'_0=ln_net_mtrXpost if occu_cat~=`occu' 
replace ln_net_mtrX`occu'_0=0 if ln_net_mtrX`occu'_0==.

gen ln_net_atrX`occu'_1=ln_net_atrXpost if  occu_cat==`occu'
replace ln_net_atrX`occu'_1=0 if ln_net_atrX`occu'_1==.
gen ln_net_atrX`occu'_0=ln_net_atrXpost if occu_cat~=`occu'
replace ln_net_atrX`occu'_0=0 if ln_net_atrX`occu'_0==.

xi: xtivreg2 d (ln_net_atrX`occu'_1 ln_net_atrX`occu'_0 = ln_net_mtrX`occu'_1 ln_net_mtrX`occu'_0  ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex if percentile==100 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) savefirst
mat f = e(first)
local F_1st = f[4,1]


test ln_net_atrX`occu'_1 = ln_net_atrX`occu'_0
local p= r(p)
local F= r(F)

outreg2  using "tabA20", addstat(p-value,`p', F-statistic,`F_1st')  stats(coef se)  excel tex(frag) bdec(3) append

if `occu' < 4 {

xi: xtivreg2 d (ln_net_atrX`occu'_1 ln_net_atrX`occu'_0 = ln_net_mtrX`occu'_1 ln_net_mtrX`occu'_0    ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 &  occu_cat>=`occu', fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) savefirst
est sto OCCU`occu'

mat f = e(first)
local F_1st = f[4,1]

test ln_net_atrX`occu'_1 = ln_net_atrX`occu'_0
local p= r(p)
local F= r(F)

outreg2  using "tabA20",  addstat(p-value,`p', F-statistic, `F_1st')  stats(coef se)  excel tex(frag) bdec(3) append
}

}



label var ln_net_atrX1_1 "self-employed"
label var ln_net_atrX2_1 "engineers, college graduates"
label var ln_net_atrX3_1 "managers and graduate assistants"
label var ln_net_atrX4_1 "others"

xi: xtivreg2 d (ln_net_atrX*_1  = ln_net_mtrX*_1  ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex  , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) savefirst
mat f = e(first)
local F_1st = f[4,1]


outreg2  using "tabA20",  addstat( F-statistic, `F_1st')  stats(coef se)  excel tex(frag) bdec(3) append

coefplot , keep(ln_net_atr*_1)  title(effects by occupation) graphregion(fcolor(white)) xline(0) legend(off) ci(90) 

set scheme s2mono
graph export "fig5a.pdf", as(pdf) replace

* industry

replace sector_cat=99 if sector_cat==4
replace sector_cat=99 if sector_cat==14
replace sector_cat=99 if sector_cat==18

label define lbl_sector 1 "AGRICULTURE, FORESTRY AND FISHING (A) / MINING (B)"
label define lbl_sector 2 "MANUFACTURING (C)", add
label define lbl_sector 3 "ELECTRICITY, GAS, STEAM AND AIR CONDITIONING SUPPLY (D)", add
label define lbl_sector 4 "WATER SUPPLY; SEWERAGE, WASTE MANAGEMENT AND REMEDIATION ACTIVITIES (E)", add
label define lbl_sector 5 "CONSTRUCTION (F)", add
label define lbl_sector 6 "WHOLESALE AND RETAIL TRADE; REPAIR OF MOTOR VEHICLES AND MOTORCYCLES (G)", add
label define lbl_sector 7 "TRANSPORTATION AND STORAGE (H)", add
label define lbl_sector 8 "ACCOMMODATION AND FOOD SERVICE ACTIVITIES (I)", add
label define lbl_sector 9 "INFORMATION AND COMMUNICATION (J)", add
label define lbl_sector 10 "FINANCIAL AND INSURANCE ACTIVITIES (K)", add
label define lbl_sector 11 "REAL ESTATE ACTIVITIES (L)", add
label define lbl_sector 12 "PROFESSIONAL, SCIENTIFIC AND TECHNICAL ACTIVITIES (M)", add
label define lbl_sector 13 "ADMINISTRATIVE AND SUPPORT SERVICE ACTIVITIES (N)", add
label define lbl_sector 14 "PUBLIC ADMINISTRATION AND DEFENCE; Compulsory Social Security (O)", add
label define lbl_sector 15 "EDUCATION (P)", add
label define lbl_sector 16 "HUMAN HEALTH AND SOCIAL WORK ACTIVITIES (Q)", add
label define lbl_sector 17 "ARTS, ENTERTAINMENT AND RECREATION (R)", add
label define lbl_sector 18 "OTHER SERVICES (S)", add
label define lbl_sector 19 "ACTIVITIES OF HOUSEHOLDS AS EMPLOYERS; UNDIFFERENTIATED GOODS- AND SERVICES-PRODUCING ACTIVITIES OF HOUSEHOLDS FOR OWN USE (T)", add
label define lbl_sector 20 "ACTIVITIES OF EXTRATERIOTORIAL ORGANISATIONS AND BODIES (U)", add
label define lbl_sector 99 "OTHER (E, O, S)", add

label values sector_cat lbl_sector

shell erase tabA21*



foreach sector of numlist  0/20 99{

gen ln_net_mtrX`sector'_1C=ln_net_mtrXpost if sector_cat==`sector'
replace ln_net_mtrX`sector'_1C=0 if ln_net_mtrX`sector'_1C==.
gen ln_net_mtrX`sector'_0C=ln_net_mtrXpost if sector_cat~=`sector' 
replace ln_net_mtrX`sector'_0C=0 if ln_net_mtrX`sector'_0C==.
replace ln_net_mtrX`sector'_0C=0 if year<2011

gen ln_net_atrX`sector'_1C=ln_net_atrXpost if  sector_cat==`sector'
replace ln_net_atrX`sector'_1C=0 if ln_net_atrX`sector'_1C==.
gen ln_net_atrX`sector'_0C=ln_net_atrXpost if sector_cat~=`sector'
replace ln_net_atrX`sector'_0C=0 if ln_net_atrX`sector'_0C==.

xi: xtivreg2 d (ln_net_atrX`sector'_1C ln_net_atrX`sector'_0C = ln_net_mtrX`sector'_1C ln_net_mtrX`sector'_0C  ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex  , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) 

outreg2  using "tabA21",  stats(coef se)  excel tex(frag) bdec(3) append

}

xi: xtivreg2 d (ln_net_atrX*_1C  = ln_net_mtrX*_1C  ) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex  , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex )
outreg2  using "tabA21",  stats(coef se)  excel tex(frag) bdec(3) append

label var ln_net_atrX1_1C "agriculture"
label var ln_net_atrX2_1C "manufacturing"
label var ln_net_atrX3_1C "electricity"
label var ln_net_atrX5_1C "construction"
label var ln_net_atrX6_1C "wholesale/retail"
label var ln_net_atrX7_1C "transportation"
label var ln_net_atrX8_1C "tourism"
label var ln_net_atrX9_1C "information"
label var ln_net_atrX10_1C "financial"
label var ln_net_atrX11_1C "real estate"
label var ln_net_atrX12_1C "professional/scientific"
label var ln_net_atrX13_1C "administrative"
label var ln_net_atrX15_1C "education"
label var ln_net_atrX16_1C "health"
label var ln_net_atrX17_1C "arts/entertainment"
label var ln_net_atrX20_1C "extraterritorial activities"
label var ln_net_atrX99_1C "other"

coefplot, keep(ln_net_atr*) title(effects by industry)  graphregion(fcolor(white)) xline(0) legend(off) ci(90) order( ln_net_atrX16_1C ln_net_atrX99_1C ln_net_atrX11_1C ln_net_atrX9_1C ln_net_atrX10_1C ln_net_atrX12_1C ln_net_atrX5_1C ln_net_atrX15_1C ln_net_atrX6_1C ln_net_atrX20_1C ln_net_atrX2_1C ln_net_atrX7_1C ln_net_atrX17_1C ln_net_atrX13_1C ln_net_atrX1_1C ln_net_atrX8_1C ln_net_atrX3_1C )

set scheme s2mono
graph export "fig5b.pdf", as(pdf) replace

*************************
*** robustness checks ***
*************************

* close to bracket test [table A11]

shell erase tabA14.*

foreach percentage of numlist 1 2.5 5  {

gen sample2=1 
replace sample2=0 if income>=(300000-(`percentage'/100)*300000)&income<=(300000+(`percentage'/100)*300000)
replace sample2=0 if income>=(175000-(`percentage'/100)*175000)&income<=(175000+(`percentage'/100)*175000)
replace sample2=0 if income>=(120000-(`percentage'/100)*120000)&income<=(120000+(`percentage'/100)*120000)
replace sample2=0 if income>=(90000-(`percentage'/100)*90000)&income<=(90000+(`percentage'/100)*90000)
replace sample2=0 if income>=(99407-(`percentage'/100)*99407)&income<=(99407+(`percentage'/100)*99407)
replace sample2=0 if income>=(80007-(`percentage'/100)*80007)&income<=(80007+(`percentage'/100)*80007)
replace sample2=0 if income>=(100000-(`percentage'/100)*100000)&income<=(100000+(`percentage'/100)*120000)&year==2012

xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex  if percentile==100 &sample2==1 , fe cluster(cluster_regionXyear id2) partial(i.jXyear $z_edu  $z_age $z_age2  $z_sex) first
mat f = e(first)
local F_1st = f[4,1]
outreg2  using "tabA14", addstat(F-statistic, `F_1st')  stats(coef se) excel tex(frag) bdec(3) append

drop sample2
}


label var income "taxable income"

foreach percentage of numlist 1 2.5 5  {

local name=`percentage'*2


gen sample`name'=1 
replace sample`name'=0 if income>=(300000-(`percentage'/100)*300000)&income<=(300000+(`percentage'/100)*300000)
replace sample`name'=0 if income>=(175000-(`percentage'/100)*175000)&income<=(175000+(`percentage'/100)*175000)
replace sample`name'=0 if income>=(120000-(`percentage'/100)*120000)&income<=(120000+(`percentage'/100)*120000)
replace sample`name'=0 if income>=(90000-(`percentage'/100)*90000)&income<=(90000+(`percentage'/100)*90000)
replace sample`name'=0 if income>=(99407-(`percentage'/100)*99407)&income<=(99407+(`percentage'/100)*99407)
replace sample`name'=0 if income>=(80007-(`percentage'/100)*80007)&income<=(80007+(`percentage'/100)*80007)
replace sample`name'=0 if income>=(100000-(`percentage'/100)*100000)&income<=(100000+(`percentage'/100)*120000)&year==2012


}

*twoway (hist income if income>60000&income<350000, wid(2000) frequ) (hist income if income>60000&income<350000 & sample10==0, wid(2000) frequ fcolor(none) lcolor(teal)) if j==1, graphregion(color(white)) xline(0) legend(off)
*graph export figR1.pdf, as(pdf) replace

* clustering [table A12]

xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex )
est sto CLUSTER_NONE
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster(id)
est sto CLUSTER_ID
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster(id2)
est sto CLUSTER_CASE
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster(code_ccaa_residence)
est sto CLUSTER_CCAA
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex  if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster(code_ccaa_residence id2)
est sto CLUSTER_CCAA_ID
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2 $z_sex   if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster(cluster_regionXyear )
est sto CLUSTER_CCAA_YR
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex  if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster( province_residence )
est sto CLUSTER_PROV
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex  if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) cluster( province_residence id2)
est sto CLUSTER_PROV_ID
xi: bootstrap, reps(100): xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) $z_j i.jXyear $z_edu  $z_age $z_age2  $z_sex  if percentile==100 , fe  partial(i.jXyear $z_edu  $z_age $z_age2 $z_sex ) 
est sto BOOT


outreg2 [CLUSTER_NONE CLUSTER_ID CLUSTER_CASE  CLUSTER_CCAA CLUSTER_CCAA_ID CLUSTER_CCAA_YR CLUSTER_PROV CLUSTER_PROV_ID BOOT] using tabA12, keep(ln_net_atrXpost)  stats(coef se  pval ci) excel tex(frag) bdec(3) replace onecol  level(90) 



* show it sums to 1

xi, noomit: ivreg2 d (ln_net_atr`period' = ln_net_mtr`period') i.id2  $z_j i.jXyear $z_edu  $z_age  $z_age2  $z_sex   ,     nocon

set matsize 11000
predict yhat3, xb
by id2, sort: egen phat3 = sum(yhat3)
tab phat3


************************
*** non-linear model ***
************************

gen age2=age*age
gen sex_male=1 if sex==1
replace sex_male=0 if sex_male==.

set seed 1234567

keep if percentile==100&move==1

asclogit d ln_net_atrXpost $z_j , altern(j) casev(i.year age age2 edu_uni sex_male) case(id2)  tech(bfgs)  difficult cluster(cluster_regionXyear) ltolerance(1e-8) tolerance(1e-8)  qtol(1e-8) showtol
est sto ASC1

asclogit d ln_net_mtrXpost $z_j , altern(j) casev(i.year age age2 edu_uni sex_male) case(id2)  tech(bfgs)  difficult cluster(cluster_regionXyear) ltolerance(1e-8) tolerance(1e-8)  qtol(1e-8) showtol
est sto ASC2

outreg2 [ASC1 ASC2 ]  using "tabA17",  stats(coef se) excel tex(frag) bdec(3) replace

****************************
*** read data full model ***
****************************

use "..\data\data_ind.dta", clear
set more off
set matsize 11000

global z_j i.origin i.birth i.firstwork i.workplace ln_dist1
global z_edu i.eduXj1 i.eduXj2 i.eduXj3 i.eduXj4 i.eduXj5 i.eduXj6 i.eduXj7 i.eduXj8 i.eduXj9 i.eduXj10 i.eduXj11 i.eduXj12 i.eduXj13 i.eduXj14 i.eduXj17
global z_age ageXj1 ageXj2 ageXj3 ageXj4 ageXj5 ageXj6 ageXj7 ageXj8 ageXj9 ageXj10 ageXj11 ageXj12 ageXj13 ageXj14 ageXj17
global z_age2 age2Xj1 age2Xj2 age2Xj3 age2Xj4 age2Xj5 age2Xj6 age2Xj7 age2Xj8 age2Xj9 age2Xj10 age2Xj11 age2Xj12 age2Xj13 age2Xj14 age2Xj17
global z_sex i.sexXj1 i.sexXj2 i.sexXj3 i.sexXj4 i.sexXj5 i.sexXj6 i.sexXj7 i.sexXj8 i.sexXj9 i.sexXj10 i.sexXj11 i.sexXj12 i.sexXj13 i.sexXj14 i.sexXj17

gen ln_net_mtrXpost = ln_net_mtr if year>2010
replace ln_net_mtrXpost = 0 if year<=2010
gen ln_net_atrXpost = ln_net_atr if year>2010
replace ln_net_atrXpost = 0 if year<=2010


******************
*** full model ***
******************


keep if percentile==100

xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) i.birth i.firstwork i.workplace  i.jXyear  $z_edu  $z_age  $z_age2  $z_sex ,  fe cluster(cluster_regionXyear id) partial(i.jXyear $z_edu  $z_age  $z_age2  $z_sex   )  savefirst
outreg2  using "tabA11",  stats(coef se) excel tex(frag) bdec(3) replace

keep if (move==1|move_prov==1|move_nbh==1)
xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) i.birth i.firstwork i.workplace i.jXyear  $z_edu  $z_age  $z_age2  $z_sex  if (move_nbh==1|move_prov==1)  ,  fe cluster(cluster_regionXyear id) partial(i.jXyear $z_edu  $z_age  $z_age2  $z_sex   )  savefirst
outreg2  using "tabA11",  stats(coef se) excel tex(frag) bdec(3) append

xi: xtivreg2 d (ln_net_atrXpost = ln_net_mtrXpost) i.birth i.firstwork i.workplace  i.jXyear $z_edu  $z_age  $z_age2  $z_sex  if (move_nbh==1|move_prov==1) & move~=1 ,  fe cluster(cluster_regionXyear id) partial(i.jXyear $z_edu  $z_age  $z_age2  $z_sex   )  savefirst
outreg2  using "tabA11",  stats(coef se) excel tex(frag) bdec(3) append


log close 
