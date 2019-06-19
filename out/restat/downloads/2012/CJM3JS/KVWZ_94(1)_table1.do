clear all

set more 1
set mat 800
set mem 150M
set logtype text

cd "C:\Data\PSID\Injury\RESTAT files"

capture log close

log using "KVWZ_94(1)_table1.txt",replace

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


*****************************
*****************************



/* define panel id variables */

iis id
tis year

/* define year dummies and other vars for regression */

tab year, gen(yr_)
g age2=age^2
tab state_fips, gen(state)
tab sic, gen(sic)

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
tab cendiv, gen(cendiv)


/* 1-yr changes in annual and 3-year fatality rate */


g pct_chng=100*(fatalrate_ - lagfatal_)/lagfatal_
g pct_chng3b=100*(fatalrate3b_ - lagfatal3b_)/lagfatal3b_

g fatal=fatalrate_
g fatal3=fatalrate3b_

sum  rwage lnrwage age marry white union educ neast ncent south west indd1 ///
indd2 indd3 indd4 indd5 indd6 indd7 indd8 indd9 indd10 occ1 occ2 occ3 occ4 ///
occ5 occ6 occ7 occ8 occ9 occ10 fatalrate_ fatalrate3b_ ///
if pct_chng>-75 & pct_chng<300

log close

