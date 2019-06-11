****************************************************************************
******************* Preparation of the income dataset **********************
*******************                                   **********************
****************************************************************************


use 1996, clear
set more off
drop if v217>=. //drop all missings from the income variable

//generate numerical country variable
decode v3, gen(country)
encode country, gen(cid)
sort cid
***Preparation of the group variables
**Income
gen income=.

//generate a new variable indicating the income quantile
forvalues k=1/24 {
xtile income`k'=v217 if cid==`k', nquantiles(10)
replace income=income`k' if cid==`k'
}

**Social class
replace v214=0 if v214==9995 //recode category "no employee" to 0

//create egp classification from isco code & other variables
iscoegp soclass1, isco(v208) sempl(v213) supvis(v214) //when v208 is ISCO-68
iskoegp soclass, isko(v208) sempl(v213) supvis(v214) //when v208 is ISCO-88

//create only one variable for the social class
replace soclass=soclass1 if country=="N"|country=="E"|country=="USA" ///
|country=="IL" 
drop soclass1

//simplify categories (only 3)
recode soclass (1 2=1) (3 4 5 7=2) (8 9 10 11=3) 
label define soclass 1 "upper class" 2 "middle class" 3 "lower class"
label values soclass soclass

**Education
//simplify categories (only 3)
rename v205 degree
recode degree (1 2 3=1) (4 5=2) (6 7=3)
label define degree 1 "low education" 2 "medium education" 3 "higher education"
label values degree degree

**Age
//create categorical age variable
rename v201 age
gen agecat=3 if age<.
replace agecat=2 if age<55
replace agecat=1 if age<35

***Group size and mean
sort v3 agecat degree soclass
by v3 agecat degree soclass: egen size=count(v2)
by v3 agecat degree soclass: egen av_income=mean(income)

***Finalization
gen year=1996
drop if cid==2|cid==5|cid==12|cid==13|cid==16|cid==20|cid==21 //keep only countries of interest
replace country="DE" if country=="D-E"|country=="D-W" //only one category for East and West Germany
replace country="CA" if country=="CDN"

//only keep one observation for each cell
egen pick=tag(country agecat degree soclass)
drop if pick==0
keep country year agecat degree soclass size av_income

//create country-year variables
gen cnt_yr="AU_1996" if country=="AUS"
replace cnt_yr="CA_1996" if country=="CA"
replace cnt_yr="CH_1996" if country=="CH"
replace cnt_yr="CZ_1996" if country=="CZ"
replace cnt_yr="DE_1996" if country=="DE"
replace cnt_yr="ES_1996" if country=="E"
replace cnt_yr="FR_1996" if country=="F"
replace cnt_yr="HU_1996" if country=="H"
replace cnt_yr="IE_1996" if country=="IRL"
replace cnt_yr="NO_1996" if country=="N"
replace cnt_yr="NZ_1996" if country=="NZ"
replace cnt_yr="PL_1996" if country=="PL"
replace cnt_yr="SI_1996" if country=="SLO"
replace cnt_yr="US_1996" if country=="USA"
save inc1996, replace

//same procedure as before for 2006
use 2006, clear
***Preparation of the group variables
**Income
foreach var of varlist AU_RINC CH_RINC CZ_RINC-DK_RINC ES_RINC-GB_RINC HU_RINC IE_RINC JP_RINC NL_RINC-NZ_RINC PL_RINC PT_RINC SE_RINC SI_RINC US_RINC {
xtile dec_`var'=`var' if `var'<., nquantiles(10)
}
gen income=.
gen incdecil=CA_RINC/10000
replace income=incdecil if V3a==124
drop incdecil
foreach var of varlist AU_RINC CH_RINC CZ_RINC-DK_RINC ES_RINC-GB_RINC HU_RINC IE_RINC JP_RINC NL_RINC-NZ_RINC PL_RINC PT_RINC SE_RINC SI_RINC US_RINC {
replace income=dec_`var' if `var'<.
}

**Social class
replace nemploy=0 if nemploy==9995
iskoegp soclass, isko(ISCO88) sempl(wrksup) supvis(nemploy)
recode soclass (1 2=1) (3 4 5 7=2) (8 9 10 11=3)
label define soclass 1 "upper class" 2 "middle class" 3 "lower class"
label values soclass soclass

**Education
replace degree=. if degree>5
recode degree (0 1=1) (2 3=2) (4 5=3)
label define degree 1 "low education" 2 "medium education" 3 "higher education"
label values degree degree

**Age
gen agecat=3 if age<.
replace agecat=2 if age<55
replace agecat=1 if age<35

***Group size and means
sort V3a agecat degree soclass
by V3a agecat degree soclass: egen size=count(V2)
by V3a agecat degree soclass: egen av_income=mean(income)
by V3a agecat degree soclass: egen sd_income=sd(income)

***Finalization
keep V3a agecat degree soclass size av_income sd_income 
keep if V3a==840 | V3a==752 | V3a==620 | V3a==554 | V3a==578 | V3a==528 | ///
V3a==392 | V3a==372 | V3a==826 | V3a==250 | V3a==246 | V3a==724 | ///
V3a==208 | V3a==276 | V3a==756 | V3a==124 | V3a==36 | V3a==203 | ///
V3a==348 | V3a==616 | V3a==705

gen year=2006
decode V3a, gen(country)
egen pick=tag(country agecat degree soclass)
drop if pick==0
keep country year agecat degree soclass size av_income sd_income

gen cnt_yr="AU_2006" if country=="AU-Australia"
replace cnt_yr="CA_2006" if country=="CA-Canada"
replace cnt_yr="CH_2006" if country=="CH-Switzerland"
replace cnt_yr="CZ_2006" if country=="CZ-Czech Republic"
replace cnt_yr="DE_2006" if country=="DE-Germany"
replace cnt_yr="DK_2006" if country=="DK-Denmark"
replace cnt_yr="ES_2006" if country=="ES-Spain"
replace cnt_yr="FI_2006" if country=="FI-Finland"
replace cnt_yr="FR_2006" if country=="FR-France"
replace cnt_yr="GB_2006" if country=="GB-Great Britain"
replace cnt_yr="HU_2006" if country=="HU-Hungary"
replace cnt_yr="IE_2006" if country=="IE-Ireland"
replace cnt_yr="JP_2006" if country=="JP-Japan"
replace cnt_yr="NL_2006" if country=="NL-Netherlands"
replace cnt_yr="NO_2006" if country=="NO-Norway"
replace cnt_yr="NZ_2006" if country=="NZ-New Zealand"
replace cnt_yr="PL_2006" if country=="PL-Poland"
replace cnt_yr="PT_2006" if country=="PT-Portugal"
replace cnt_yr="SE_2006" if country=="SE-Sweden"
replace cnt_yr="SI_2006" if country=="SI-Slovenia"
replace cnt_yr="US_2006" if country=="US-United States"
save inc2006, replace

.
