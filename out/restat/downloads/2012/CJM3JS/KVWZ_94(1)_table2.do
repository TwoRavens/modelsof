clear all

set more 1
set mat 800
set mem 150M
set logtype text

cd "C:\Data\PSID\Injury\RESTAT files"

capture log close

log using "KVWZ_94(1)_table2.txt",replace

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



/* 1-yr changes in annual and 3-yr fatality rate */


g pct_chng=100*(fatalrate_ - lagfatal_)/lagfatal_
g pct_chng3b=100*(fatalrate3b_ - lagfatal3b_)/lagfatal3b_

g fatal=fatalrate_
g fatal3=fatalrate3b_



/* Calculating Total (tvfatal), Within (wvfatal), and Between (bvfatal) Group Variation */

/* POOLED Sample in top panel of Table 2 */

g fdid=id-id[_n-1]

sort id

g nobs=_N


g tvar=r(Tbar)

egen mfatal1=mean(fatal) if pct_chng>-75 & pct_chng<300
egen tvfatal1=sum((fatal-mfatal1)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300
by id: egen mfatal1i=mean(fatal) if pct_chng>-75 & pct_chng<300
egen wvfatal1=sum((fatal-mfatal1i)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300

g bvfatal1=tvfatal1-wvfatal1 if pct_chng>-75 & pct_chng<300

egen mfatal3=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen tvfatal3=sum((fatal3-mfatal3)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300
by id: egen mfatal3i=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen wvfatal3=sum((fatal3-mfatal3i)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300

g bvfatal3=tvfatal3-wvfatal3 if pct_chng3b>-75 & pct_chng3b<300

sum tvfatal1 wvfatal1 bvfatal1 if pct_chng>-75 & pct_chng<300

sum tvfatal3 wvfatal3 bvfatal3 if pct_chng3b>-75 & pct_chng3b<300


drop tvfatal1 wvfatal1 bvfatal1 tvfatal3 wvfatal3 bvfatal3 mfatal1 mfatal1i mfatal3 mfatal3i nobs


/* Define JOB CHANGERS */
 


tsset id year

g d_indocc=indocc-l2.indocc

g changer=1 if d_indocc~=0
replace changer=0 if changer==.
replace changer=0 if vsum==1

tsset id vsum

g changer2=1 if indocc~=l1.indocc
replace changer2=0 if vsum==1
replace changer2=0 if changer2==.
replace changer2=0 if l1.indocc==.


sort id
by id: egen temp=max(changer2)

gen neverchg=1 if temp==0
replace neverchg=0 if temp~=0

drop temp d_indocc


sort id



*****************************
*****************************

tsset id year

g dio=indocc-l2.indocc
replace dio=. if dio==0

preserve



/*  Never Change Jobs Sample in 2nd panel of Table 2 */

keep if neverchg==1

g nobs=_N


egen mfatal1=mean(fatal) if pct_chng>-75 & pct_chng<300
egen tvfatal1=sum((fatal-mfatal1)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300
by id: egen mfatal1i=mean(fatal) if pct_chng>-75 & pct_chng<300
egen wvfatal1=sum((fatal-mfatal1i)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300

g bvfatal1=tvfatal1-wvfatal1 if pct_chng>-75 & pct_chng<300

egen mfatal3=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen tvfatal3=sum((fatal3-mfatal3)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300
by id: egen mfatal3i=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen wvfatal3=sum((fatal3-mfatal3i)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300

g bvfatal3=tvfatal3-wvfatal3 if pct_chng3b>-75 & pct_chng3b<300

sum tvfatal1 wvfatal1 bvfatal1 if pct_chng>-75 & pct_chng<300

sum tvfatal3 wvfatal3 bvfatal3 if pct_chng3b>-75 & pct_chng3b<300

drop tvfatal1 wvfatal1 bvfatal1 tvfatal3 wvfatal3 bvfatal3 mfatal1 mfatal1i mfatal3 mfatal3i nobs


/*  Ever Change Jobs Sample in 3rd panel of Table 2 */

*****
restore
preserve
******
keep if neverchg==0

g nobs=_N


egen mfatal1=mean(fatal) if pct_chng>-75 & pct_chng<300
egen tvfatal1=sum((fatal-mfatal1)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300
by id: egen mfatal1i=mean(fatal) if pct_chng>-75 & pct_chng<300
egen wvfatal1=sum((fatal-mfatal1i)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300

g bvfatal1=tvfatal1-wvfatal1 if pct_chng>-75 & pct_chng<300

egen mfatal3=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen tvfatal3=sum((fatal3-mfatal3)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300
by id: egen mfatal3i=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen wvfatal3=sum((fatal3-mfatal3i)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300

g bvfatal3=tvfatal3-wvfatal3 if pct_chng3b>-75 & pct_chng3b<300

g lagfatal1=fatal[_n-1]

g dfatal1=fatal-lagfatal1 if fdid==0
g posfat=0
replace posfat=1 if dfatal1 > 0

g negfat=0
replace negfat=1 if dfatal1 < 0


sum tvfatal1 wvfatal1 bvfatal1 if pct_chng>-75 & pct_chng<300

sum tvfatal3 wvfatal3 bvfatal3 if pct_chng3b>-75 & pct_chng3b<300

drop tvfatal1 wvfatal1 bvfatal1 tvfatal3 wvfatal3 bvfatal3 mfatal1 mfatal1i mfatal3 mfatal3i nobs

/*  When Change Jobs Sample in 4th panel of Table 2 */

*****
restore
preserve
******

keep if dio~=.

g nobs=_N


egen mfatal1=mean(fatal) if pct_chng>-75 & pct_chng<300
egen tvfatal1=sum((fatal-mfatal1)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300
by id: egen mfatal1i=mean(fatal) if pct_chng>-75 & pct_chng<300
egen wvfatal1=sum((fatal-mfatal1i)^2/(nobs-1)) if pct_chng>-75 & pct_chng<300

g bvfatal1=tvfatal1-wvfatal1 if pct_chng>-75 & pct_chng<300

egen mfatal3=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen tvfatal3=sum((fatal3-mfatal3)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300
by id: egen mfatal3i=mean(fatal3) if pct_chng3b>-75 & pct_chng3b<300
egen wvfatal3=sum((fatal3-mfatal3i)^2/(nobs-1)) if pct_chng3b>-75 & pct_chng3b<300

g bvfatal3=tvfatal3-wvfatal3 if pct_chng3b>-75 & pct_chng3b<300

sum tvfatal1 wvfatal1 bvfatal1 if pct_chng>-75 & pct_chng<300

sum tvfatal3 wvfatal3 bvfatal3 if pct_chng3b>-75 & pct_chng3b<300


drop tvfatal1 wvfatal1 bvfatal1 tvfatal3 wvfatal3 bvfatal3 mfatal1 mfatal1i mfatal3 mfatal3i nobs

*****
restore
preserve
******

log close

