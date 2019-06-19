** This file analyzes the data from the saturation count analysis
** e.g. the "Distance" analysis
* Updated March 2009

clear
clear matrix
set mem 500m
set more off


cd "C:\Users\alixgarcia\Documents\progresa\data oportunidades\"

* CLEAN UP DATA
use saturations_062310.dta, clear
capture log close
log using saturations062310.log, replace

* generate forest variable
* DROP those with no forest to start with
egen forest00 = rowtotal(area3 area4)
gen perfor00 = forest00/ lutotNFI
label var perfor00 "percent forest in 2000 (baseline forest cover)"
drop if perfor00 <.05

*** NOTE: this is the line for the decision about what sample we are running this on: change to .05 and rerun for robustness 

* generate percent deforestation (percent of area) and replace deforestation with zero where no deforestation
* note that the base is the area that was classified in the NFI 2000 (lutotNFI)
gen pctdefor = totdef/lutotNFI
replace pctdefor = 0 if totdef == .
label var pctdefor "percent deforestation 2000-2003"

*as an alternate measure, percent deforestation as a percent of baseline forest.
gen pctdeforalt = totdef/forest00
replace pctdeforalt = 0 if totdef == .
replace pctdeforalt = 1 if pctdeforalt > 1
*NOTE: only 2 have more deforestation than initial forest

*Binary measure of deforestation

gen d = pctdeforalt > 0

* controls for number of villages; code those with nocount to zero (e.g. no villages)
replace totpobi0 = ln(1+totpobi0)
replace totpobi10 = ln(1+totpobi10)
replace totpobi20 = ln(1+totpobi20)
replace totpobi30 = ln(1+totpobi30)
replace totpobi40 = ln(1+totpobi40)

replace overi0 = 0 if overi0 == .
replace overi10 = 0 if overi10 == .
replace overi20 = 0 if overi20 == .
replace overi30 = 0 if overi30 == .
replace overi40 = 0 if overi40 == .

replace overi10 = overi10 - overi0
replace overi20 = overi20 - overi10 - overi0
replace overi30 = overi30 - overi20 - overi10 - overi0
replace overi40 = overi40 - overi30 - overi20 - overi10 - overi0

replace aroundi0 = 0 if aroundi0 == .
replace aroundi10 = 0 if aroundi10 == .
replace aroundi20 = 0 if aroundi20 == .
replace aroundi30 = 0 if aroundi30 == .
replace aroundi40 = 0 if aroundi40 == .

replace aroundi10 = aroundi10 - aroundi0
replace aroundi20 = aroundi20 - aroundi10 - aroundi0
replace aroundi30 = aroundi30 - aroundi20 - aroundi10 - aroundi0
replace aroundi40 = aroundi40 - aroundi30 - aroundi20 - aroundi10 - aroundi0

gen t0 = overi0/aroundi0
gen t10 = overi10/aroundi10
gen t20 = overi20/aroundi20
gen t30 = overi30/aroundi30
gen t40 = overi40/aroundi40

* round long and lat and create fixed effects
gen midxrnd = round(midx, 500)
gen midyrnd = round(midy, 500)

** Generate interactions with distance
replace carrlength = 0 if carrlength == .
gen nearestrd = log(1+totroads10/1000)

*egen far = cut(nearestrd), group(2) label

*replace nearestrd = far
sum nearestrd

gen trd0 = t0*nearestrd
gen trd10 = t10*nearestrd
gen trd20 = t20*nearestrd
gen trd30 = t30*nearestrd
gen trd40 = t40*nearestrd

replace povmeani0 = 0 if povmeani0 == .
replace povmeani10 = 0 if povmeani10 == .
replace povmeani20 = 0 if povmeani20 == .
replace povmeani30 = 0 if povmeani30 == .
replace povmeani40 = 0 if povmeani40 == .


** Regression with binary dependent variable

gen zeroi0 = aroundi0 == 0
gen zeroi10 = aroundi10 == 0
gen zeroi20 = aroundi20 == 0
gen zeroi30 = aroundi30 == 0
gen zeroi40 = aroundi40 == 0

drop if zeroi0 == 1 & zeroi10 == 1  & zeroi20 == 1  & zeroi30 == 1  & zeroi40 == 1  

replace t0 = 0 if t0 ==.
replace t10 = 0 if t10 ==.
replace t20 = 0 if t20 ==.
replace t30 = 0 if t30 ==.
replace t40 = 0 if t40 ==.

replace trd0 = 0 if trd0 ==.
replace trd10 = 0 if trd10 ==.
replace trd20 = 0 if trd20 ==.
replace trd30 = 0 if trd30 ==.
replace trd40 = 0 if trd40 ==.


xi: reg d t0 t10 t20 t30 t40 nearestrd forest00 povmeani40 totpobi0 totpobi10 totpobi20 totpobi30 totpobi40 zeroi0 zeroi10 zeroi20 zeroi30 zeroi40 i.midxrnd i.midyrnd, vce(bootstrap, reps(50))
xi: reg d t0 t10 t20 t30 t40 trd0 trd10 trd20 trd30 trd40 nearestrd totpobi0 totpobi10 totpobi20 totpobi30 totpobi40 forest00 povmeani40 zeroi0 zeroi10 zeroi20  zeroi30 zeroi40  i.midxrnd i.midyrnd, vce(bootstrap, reps(100) seed(123456789))

gen medianrds = totroads10<495000

gen t0median = t0*medianrds
gen t10median = t10*medianrds
gen t20median = t20*medianrds
gen t30median = t30*medianrds
gen t40median = t40*medianrds

xi: reg d t0 t10 t20 t30 t40 t0median t10median t20median t30median t40median medianrds totpobi0 totpobi10 totpobi20 totpobi30 totpobi40 forest00 povmeani40 zeroi0 zeroi10 zeroi20  zeroi30 zeroi40  i.midxrnd i.midyrnd, vce(bootstrap, reps(100) seed(123456789))

lincom t0+t0median
lincom t10+t10median
lincom t20+t20median
lincom t30+t20median
lincom t40+t40median
