clear all

set more 1
set mat 800
set mem 150M
set logtype text

cd "C:\Data\PSID\Injury\RESTAT files"

capture log close

log using "KVWZ_94(1)_table3_cols3-5.txt",replace

use "C:\Data\PSID\Injury\Feb10\pandat_mar08.dta"

drop if lagfatal_==.
g lagfatal=lagfatal_

*****************************
*****************************
* identifying individuals in sample only once
*****************************

sort id

g one=1

by id: g vsum=sum(one)

tsset id year

by id: egen tempvar=max(vsum)

gen solo=1 if tempvar==1
replace solo=0 if tempvar~=1

drop tempvar



/* define panel id variables */

iis id
tis year

/* define year dummies and other vars for regression */

quietly tab year, gen(yr_)
g age2=age^2
quietly tab state_fips, gen(state)
quietly tab sic, gen(sic)

/* Census Divisions --- http://www.census.gov/geo/www/us_regdiv.pdf */
/* State FIPS Codes --- http://www.bls.gov/lau/lausfips.htm */

g cendiv=1 if state_fips==9 | state_fips==23 | state_fips==25 | state_fips==33 | state_fips==44 | state_fips==50
replace cendiv=2 if state_fips==34 | state_fips==36 | state_fips==42
replace cendiv=3 if state_fips==17 | state_fips==18 | state_fips==26 | state_fips==39 | state_fips==55
replace cendiv=4 if state_fips==19 | state_fips==20 | state_fips==27 | state_fips==29 | state_fips==31 | state_fips==38 | state_fips==46
replace cendiv=5 if state_fips==10 | state_fips==11 | state_fips==12 | state_fips==13 | state_fips==24 | state_fips==37 | state_fips==45 | state_fips==51 | state_fips==54
replace cendiv=6 if state_fips==1 | state_fips==21 | state_fips==28 | state_fips==47
replace cendiv=7 if state_fips==5 | state_fips==22 | state_fips==40 | state_fips==48
replace cendiv=8 if state_fips==4 | state_fips==8 | state_fips==16 | state_fips==30 | state_fips==32 | state_fips==35 | state_fips==49 | state_fips==56
replace cendiv=9 if state_fips==2 | state_fips==6 | state_fips==15 | state_fips==41 | state_fips==53
quietly tab cendiv, gen(cendiv)


/* 1-yr changes in fatality rate */

tsset id year
g pct_chng=100*(fatalrate_ - lagfatal_)/lagfatal_
g pct_chng3b=100*(fatalrate3b_ - lagfatal3b_)/lagfatal3b_

g lagpct_chng=100*(lagfatal_ - lag2fatal_)/lag2fatal_
g lagpct_chng3b=100*(lagfatal3b_ - lag2fatal3b_)/lag2fatal3b_

/* @@@@@@@@@@@ Columm 3 of Table 3--pooled time series cross section @@@@@@@@@@@ */

/* annual fatality models */

g fatal=fatalrate_

reg lnrwage fatal educ age age2 cendiv2-cendiv9 union marry white occ1-occ9 sic2-sic66 state2-state50 yr_2-yr_5 if pct_chng>-75 & pct_chng<300, robust cluster(indocc)
est store pols1

g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)

/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[fatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[fatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf



/* 3-year fatality models (B) */

replace fatal=fatalrate3b_

reg lnrwage fatal educ age age2 cendiv2-cendiv9 union marry white occ1-occ9 sic2-sic66 state2-state50 yr_2-yr_5 if pct_chng3b>-75 & pct_chng3b<300, robust cluster(indocc)
est store pols3

g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[fatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[fatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf



/* @@@@@@@@@@@ Columns 4-5 of Table 3-- RANDOM, AND BETWEEN ESTIMATORS @@@@@@@@@@@ */


/* annual fatality models */

replace fatal=fatalrate_

xtreg lnrwage fatal educ age age2 cendiv2-cendiv9 union marry white occ1-occ9 sic2-sic66 yr_2-yr_5 state2-state50 if pct_chng>-75 & pct_chng<300, be 
est store be1

g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[fatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[fatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf


xtreg lnrwage fatal educ age age2 cendiv2-cendiv9 union marry white occ1-occ9 sic2-sic66 yr_2-yr_5  state2-state50 if pct_chng>-75 & pct_chng<300, re
est store re1

g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */

g ivl1=_b[fatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[fatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf


/* 3-year fatality models (B) */

replace fatal=fatalrate3b_

xtreg lnrwage fatal educ age age2 cendiv2-cendiv9 union marry white occ1-occ9 sic2-sic66 yr_2-yr_5 state2-state50 if pct_chng3b>-75 & pct_chng3b<300, be 

est store be3
g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[fatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[fatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf


xtreg lnrwage fatal educ age age2 cendiv2-cendiv9 union marry white occ1-occ9 sic2-sic66 yr_2-yr_5 state2-state50 if pct_chng3b>-75 & pct_chng3b<300, re

est store re3
g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[fatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[fatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf



log close
