* This program analyzes the voucher survey data


log using survey, replace

* Estimate Tables Based on High School Sample

use survey_hschool

drop if minority==.
drop if children==2
drop if voucher>2
drop if race==.

gen yes = (voucher==1)
gen owner = (own==1)
gen renter = (own==2)

gen coll = (educ>2)
replace coll=. if educ==.

gen white = (race==4)
gen asian = (race==1)
gen rep = (republican==2)
gen female = (gender==2)

gen income1=10000 if income==1
replace income1=30000 if income==2
replace income1=50000 if income==3
replace income1=70000 if income==4
replace income1=90000 if income==5
replace income1=150000 if income==6
gen lincome=log(income1)
recode lincome .=0


gen lapi=log(api)
tab region, gen(r)


su yes owner rep female minority sphisp spblack spasian if white==1 & children==1 & maxafact>.74
su yes owner rep female minority sphisp spblack spasian if white==0 & children==1 & maxafact>.74


* Generate dummies for missing income data
gen minc=1 if income==.
recode minc .=0
replace income1=0 if income1==.

gen mown=1 if own==.
recode mown .=0
recode owner .=0


local controls1 owner rep female srural mown r1 r2 r3 r4 r5 r6 r7

*  Table 2


areg yes minority if children==1 & white==1 & maxafact>.74, absorb(region) cluster(dcode)

reg yes minority `controls1'  if children==1 & white==1 & maxafact>.74, cluster(dcode)

reg yes minority `controls1' linc coll minc if children==1 & white==1 & maxafact>.74, cluster(dcode)


* Table 3

reg yes minority `controls1'  if children==1 & white==1 & maxafact>.74, cluster(dcode)

reg yes minority `controls1' if children==1 & white==0 & maxafact>.74, cluster(dcode)

reg yes minority `controls1'  if children==3 & white==1 & maxafact>.74, cluster(dcode)



*  Table 5 Column 1


reg yes minority `controls1'  if children==1 & white==1 & maxafact>.74, cluster(dcode)

reg yes sphisp spblack spasian `controls1' if children==1 & white==1 & maxafact>.74, cluster(dcode)

reg yes lep_minority nlep_minority `controls1' if children==1 & white==1 & maxafact>.74, cluster(dcode)

reg yes lep_sphisp nlep_sphisp lep_spasian nlep_spasian spblack `controls1'  if children==1 & white==1 & maxafact>.74, cluster(dcode)

reg yes minority lapi `controls1' if children==1 & white==1 & maxafact>.74, cluster(dcode)


*  Table 5 Column 2

reg yes minority `controls1' if children==1 & white==0 & maxafact>.74, cluster(dcode)

reg yes sphisp spblack spasian `controls1'  if children==1 & white==0 & maxafact>.74, cluster(dcode)

reg yes lep_minority nlep_minority `controls1'  if children==1 & white==0 & maxafact>.74, cluster(dcode)

reg yes lep_sphisp nlep_sphisp lep_spasian nlep_spasian spblack `controls1' if children==1 & white==0 & maxafact>.74, cluster(dcode)

reg yes minority lapi `controls1' if children==1 & white==0 & maxafact>.74, cluster(dcode)



* Estimate Tables Based on Elementary School Sample
clear

use survey_eschools

drop if minority==.
drop if children==2
drop if voucher>2
drop if race==.

gen yes = (voucher==1)
gen owner = (own==1)
gen renter = (own==2)

gen coll = (educ>2)
replace coll=. if educ==.

gen white = (race==4)
gen asian = (race==1)
gen rep = (republican==2)
gen female = (gender==2)

gen income1=10000 if income==1
replace income1=30000 if income==2
replace income1=50000 if income==3
replace income1=70000 if income==4
replace income1=90000 if income==5
replace income1=150000 if income==6
gen lincome=log(income1)
recode lincome .=0

gen srural = (popstat>4)
gen srural_cs = (popstat_cs>4)

tab region, gen(r)

* Generate dummies for missing income data
gen mown=1 if own==.
recode mown .=0
recode owner .=0


local controls1 owner rep female srural_cs mown r1 r2 r3 r4 r5 r6 r7
local controls2 owner rep female srural mown r1 r2 r3 r4 r5 r6 r7

*  Table 4
* Closest Elementary School
reg yes minority_cs `controls1'  if children==1 & white==1 & maxafact>.74, cluster(dcode)
reg yes minority_cs `controls1'  if children==1 & white==0 & maxafact>.74, cluster(dcode)
reg yes minority_cs `controls1'  if children==3 & white==1 & maxafact>.74, cluster(dcode)

* Three Closest Elementary Schools
reg yes minority `controls2'  if children==1 & white==1 & maxafact>.74, cluster(dcode)
reg yes minority `controls2'  if children==1 & white==0 & maxafact>.74, cluster(dcode)
reg yes minority `controls2'  if children==3 & white==1 & maxafact>.74, cluster(dcode)
