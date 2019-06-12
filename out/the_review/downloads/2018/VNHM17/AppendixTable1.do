****************************************************************************************
* Replication Code: Appendix Table 1
* Balance Between Staffer Survey Balance Statistics
* This code created: 6/13/18
****************************************************************************************

* Note that this code cannot be run on publicly posted replication data
* This code requires individually-identified survey data

*
* Load Qualtrics data from exported CSV
*

cd "/Users/ahertel/Dropbox/LegislativeStafferResults"
import delimited "Survey/LegislativeStaffer.csv", clear

*
* Drop if email cannot be identified
*

drop if emailaddress==""

*
* Drop if consent not given
*

drop if q23!=1 & consent!=1

*
* Drop our test records
*

drop if emailaddress=="ghenderson@umail.ucsb.edu"
drop if emailaddress=="alexander.hertel@gmail.com"
drop if emailaddress=="ah3467@columbia.edu"
drop if emailaddress=="mildenberger@polsci.ucsb.edu"
drop if emailaddress=="stokes@polsci.ucsb.edu"

*
* Merge in office information by email
*

merge 1:1 emailaddress using "Survey/Staffer Information.dta"
gen insamp = _m==3
drop _m

*
* Clean survey
*

gen stateabb=state

gen senate = senatehouse=="S"
gen house = senatehouse=="H"

gen chamber = "senate" if senate==1
replace chamber = "house" if house==1

replace cos = 0 if cos!=1
replace ld = 0 if ld!=1

recode parenteduc_1 (7/8=.), gen(mothereduc)
recode parenteduc_2 (7/8=.), gen(fathereduc)
gen parenteducsum = (mothereduc+fathereduc)

gen district = congressionaldistrict
replace district = "1" if district=="At Large"
destring district, replace

replace lastname=lower(lastname)

tab memberparty, gen(party_)
rename party_1 democrat
rename party_2 republican

replace lastname = "la malfa" if lastname=="lamalfa"
replace lastname = "diaz" if lastname=="diaz-balart"
replace lastname = "jackson lee" if lastname=="jackson-lee"
replace lastname = "orourke" if lastname=="o'rourke"

*
* Merge in regions
*

merge m:1 stateabb using "Covariates/States and Census Regions and Divisions.dta"
drop if _m==2
drop _m

tab region, gen(region_)
tab division, gen(division_)

*
* Merge in dummy for whether Member is in party/chamber leadership position
*

merge m:1 chamber district stateabb lastname using "Covariates/leaders.dta"
drop if _m==2
drop _m
replace leader = 0 if leader!=1

*
* Merge in seniority in 2016 (consecutive years in Congress)
*

merge m:1 chamber stateabb district lastname using "Covariates/congseniority.dta"
drop if _m==2
drop _m
gen memberyears=2016-firstyearcong

*
* Merge in DW-NOMINATE score
*

merge m:1 chamber district stateabb lastname using "Covariates/senatedwn.dta"
drop _m

merge m:1 chamber district stateabb lastname using "Covariates/housedwn.dta"
drop _m

gen dwnom1 = dwnom1_house if chamber=="house"
replace dwnom1 = dwnom1_senate if chamber=="senate"

gen dwnom2 = dwnom2_house if chamber=="house"
replace dwnom2 = dwnom2_senate if chamber=="senate"

*
* Output table with survey and sample means, plus p-values
*

cd "/Users/ahertel/Dropbox/LegislativeStafferResults/APSR Submission/Replication/"

tempname fullsurveydims

postfile `fullsurveydims' str40 covar surveymean samplemean dimpvalue using "fullsurveydims.dta", replace

foreach var of varlist cos ld house senate democrat republican region_* division_* leadership memberyears {
	xi: reg `var' insamp , cluster(office)
	gen tempsurveymean = _b[_cons] +  _b[insamp]
	gen t = _b[insamp]/_se[insamp]
	gen p =2*ttail(e(df_r),abs(t))
	post `fullsurveydims' ("`var'") (tempsurveymean) (`=_b[_cons]') (p)
	drop tempsurveymean t p
}

xi: reg dwnom1 insamp if democrat==1, cluster(office)
gen tempsurveymean = _b[_cons] +  _b[insamp]
gen t = _b[insamp]/_se[insamp]
gen p =2*ttail(e(df_r),abs(t))
post `fullsurveydims' ("dwnom1_dem") (tempsurveymean) (`=_b[_cons]') (p)
drop tempsurveymean t p 

xi: reg dwnom1 insamp if democrat==0, cluster(office)
gen tempsurveymean = _b[_cons] +  _b[insamp]
gen t = _b[insamp]/_se[insamp]
gen p =2*ttail(e(df_r),abs(t))
post `fullsurveydims' ("dwnom1_rep") (tempsurveymean) (`=_b[_cons]') (p)
drop tempsurveymean t p

postclose `fullsurveydims'

* 
* Summarize DW-NOMINATE by party
*

bys memberparty: sum dwnom1 if memberparty!="", d

bys memberparty: sum dwnom1 if memberparty!="" & insamp==1, d

*
* Summarize median years in Congress
*

sum memberyears, d
sum memberyears if insamp==1,d

*
* Load table with differences in means
*

use "fullsurveydims.dta", clear
