**********************************
*	Title: hivlabor_5a2.do
*	Date: 16 November 2007
*   Edited:  Jim L.  April 2009
*	Author: Zoe McLaren
*	Description: 
*		1. Creates table A2   

**********************************
clear
clear matrix
version 8
*Use individual data, with hh roster data merged in, and labor.do run to create variables.
use "$data/hhindiv04_labor.dta", clear

*Merge in BED and vload data here
sort barcode
cap drop _merge
merge (barcode) using "$stata/bed_stata2.dta"
assert _merge==1 | _merge==3
ren _merge _mergebed
sort barcode
merge (barcode) using "$stata/viralload_stata2.dta"
*5 obs only in the vload data have no viralload, so drop them
ren _merge _mergevload
drop if _mergevload==2
*age discrepancies: 46 have agediff>2
gen agediff = age-age_v
gen agediff_d=(abs(agediff)>2 & agediff~=.)
****

cap drop pscore

*benchmarked weight irrespective of blood sample given (to map up to population); this weight does NOT correct for testing selection
gen weight = ibreal12

*** GENERATE VARIABLES WITH ALL INDIVS STILL IN DATA SET (including children) ***
*HIV+ any age
assert hhid~=.
cap drop temp
gen temp=1 if positive==1
egen sumhiv_positive=sum(temp), by(hhid)
gen anyhiv_positive=(sumhiv_positive>0 & sumhiv_positive~=.)
*identifies HIV+ who are not the only HIV+ in hhold (doesn't identify anyone HIV-)
gen anyotherhiv_positive=(sumhiv_positive>1 & sumhiv_positive~=. & positive==1)
replace temp=.

*HIV+ 14 and under
replace temp=1 if positive==1 & age<=14
egen sumhiv_positive14under=sum(temp), by(hhid)
gen anyhiv_positive14under=(sumhiv_positive14under>0 & sumhiv_positive14under~=.)
*note: not creating "anyotherhiv" for children
replace temp=.

*HIV+ 15 and over
replace temp=1 if positive==1 & age>=15 & age~=.
egen sumhiv_positive15plus=sum(temp), by(hhid)
gen anyhiv_positive15plus=(sumhiv_positive15plus>0 & sumhiv_positive15plus~=.)
gen anyotherhiv_positive15plus=(sumhiv_positive15plus>1 & sumhiv_positive15plus~=. & positive==1 & age>=15 & age~=.)
replace temp=.

*** DROP PEOPLE UNDER 15 YEARS OLD ***
keep if group==1
count

*** CREATE OUTCOME VARS OF INTEREST (ALL USING BROAD UNEMPLOYMENT DEFINITION) ***
gen nea = (employment==1 | employment==6 | employment==7 | employment==8)
lab var nea "homemaker, oap, disabled, student - not econ active"
gen housewife=(employment==1 | employment==2) 
cap drop employed
gen employed = (employment==5 | employment==9 | employment==10 | employment==11 | employment==12)
lab var employed "employed full or part time, formal or informal sector"
gen parttime = (employment==10 | employment==12)
lab var parttime "employed or self-employed part-time only"
gen unemployed = (employment==2 | employment==3 | employment==4)
gen searching=(employment==2 | employment==3)
lab var searching "looking for work (unemployed or homemaker)"
gen student=(employment==8)
lab var student "student/pupil/learner"
gen selfemployed=(employment==9 | employment==10)
label var selfemployed "self-employed"

*create dummy for missing or other employment status
gen employment_d =(employment==. | employment==13)

*** CLEAN A FEW OTHER VARIABLES ***
ren q5d landline
recode landline (2=0)
ren q10 hhmigrant
recode hhmigrant (2=0)
ren q3 cooking

foreach var of varlist watersource cooking toilet landline hhmigrant {
	gen `var'_d=0
	label var `var'_d "dummy==1 if imputed to zero from missing"
	replace `var'_d=1 if `var'==.
	replace `var'=0 if `var'==.
	tab `var' `var'_d, mi
}
foreach var of varlist watersource1-watersource8 cooking1-cooking4 toilet1-toilet5 {
	replace `var'=0 if `var'==.
}
gen noroster_d=(weight_hh==.)
label var noroster_d "dummy==1 for not matched to household roster (no hh variables)"

gen nevermarried=(marstat==1)
gen know1=(trans_vag==1)
gen know2=(AIDSwitch==2)
gen know3=(prev_condom==1)
gen know4=(reduce_part==1)

gen know1_d=(trans_vag==.)
gen know2_d=(AIDSwitch==.)
gen know3_d=(prev_condom==.)
gen know4_d=(reduce_part==.)


*Create dummies for having male or female pensioner in the household
gen malepension=0
gen fempension=0
forvalues i = 1/33 {
	replace malepension=1 if sex`i'==1 & age`i'>=65
	replace fempension=1 if sex`i'==2 & age`i'>=60
}

gen knowstatus=(test_informed==1)

gen age35plus=(age>=35 & age~=.)

xi i.primary*age35plus i.secondary*age35plus i.matric*age35plus i.tertiary*age35plus i.condom_first*age35plus i.know1*age35plus i.know2*age35plus i.know3*age35plus i.know4*age35plus

*** SELECT VARIABLES FOR PSCORE ***
#delimit;
global vars		`"age agesq female african coloured indian province2-province9
						urban nevermarried hadsex sexage sexagesq  
							primary secondary matric tertiary "';

global newvars	`"condom_first know1 know2 know3 know4 malepension fempension"';

global vars_endog `"condom_last1 condom_last2 no_part no_parth tested_before test_informed ARVknow"';

global income	`"grant shelter2 shelter3 shelter4 	
			fuel2 fuel3 fuel4		water2 water3 water4 
			medicine2 medicine3 medicine4	food2 food3 food4 
			cash2 cash3 cash4"';  *notes on income: /*"often" is base category for income vars*/;

global varsdum	`"age_d suspect_age female_d race_d province_d urban_d marstat_d 
			 hadsex_d sexage_d condom_first_d know1_d know2_d know3_d know4_d"';

global varsdum2	`"condom_last_d no_part_d no_parth_d tested_before_d test_informed_d ARVknow_d   "';

global interactions `"_IpriXage35_1 _IsecXage35_1 _ImatXage35_1 _IterXage35_1 _IconXage35_1 _IknoXage35_1 _IknoXage35a1 _IknoXage35b1 _IknoXage35c1 "';

global additional "";

global hhvars "watersource1-watersource8 toilet1-toilet5 cooking1-cooking4 
			electricity fridge radio tv landline hhmigrant noroster_d ";

global hhvarssubset "toilet1-toilet5 cooking1-cooking4 electricity landline noroster_d ";
# delimit cr

*** GLOBAL FOR PSCORE ***
*Global special is list of variables to produce results in regloop.do 
global special "$vars $newvars $varsdum"
global allvars "$vars $newvars $vars_endog $income $varsdum $varsdum2 $interactions $additional $hhvars"

*** GENERATE MATRICES OF RESULTS using positive, latent and highvload ***
* Regloop.do creates matrices of results
save "$output/hivlabor_5end.dta", replace
*Drop non-Africans per referee request
drop if african~=1
do "$syntax/regloop10a2.do"

exit  
 
