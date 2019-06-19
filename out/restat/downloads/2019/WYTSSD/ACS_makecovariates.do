clear all

********************************************************************************/

use ACS1yr_2006to2012.dta, clear
keep if year==2007 | year==2010 | year==2011 | year==2012

preserve
gen educstr=""
replace educstr="nobd" if educ<=8
replace educstr="bd" if educ>8 & educ<=11
tab educstr educ

gen empstatus=""
replace empstatus="emp" if empstat==1
replace empstatus="unemp" if empstat==2
tab empstat empstatus

keep if empstat==1 | empstat==2

gen count=1

collapse (sum) num=count [pw=perwt], by(educstr empstatus statefip year)
reshape wide num, i(state educstr year ) j(empstatus) string
reshape wide num*, i(state year) j(educstr) string

gen unemprate_bd=(numunempbd/(numempbd+numunempbd))*100
gen unemprate_nobd=(numunempnobd/(numempnobd+numunempnobd))*100

keep year statefip unemprate_bd unemprate_nobd

save $pathUPS/data2/merge/acs_ur_state_educ_year.dta, replace
restore

preserve
tab empstat
keep if empstat==2

gen occsoc_broad=substr(occsoc,1,2)
destring occsoc_broad, replace

gen occsoc_broadgroup=2 if occsoc_broad>=11 & occsoc_broad<=13
replace occsoc_broadgroup=3 if occsoc_broad>=15 & occsoc_broad<=29
replace occsoc_broadgroup=4 if occsoc_broad>=31 & occsoc_broad<=39
replace occsoc_broadgroup=5 if occsoc_broad>=41 & occsoc_broad<=43
replace occsoc_broadgroup=6 if occsoc_broad>=45 & occsoc_broad<=49
replace occsoc_broadgroup=7 if occsoc_broad>=51 & occsoc_broad<=53

keep if age>=25
drop if occsoc_broadgroup==.

gen count=1
collapse (sum) count [pw=perwt], by(statefip year occsoc_broadgroup)

save acs_unemplevel_state_occsoc_broadgroup.dta, replace
restore

gen occsoc_minor = substr(occsoc,1,3)
drop occsoc

keep if empstat==1

gen ind2="Agriculture, Forestry, Fishing and Hunting" if substr(indnaics,1,2)=="11" 
replace ind2="Mining" if substr(indnaics,1,2)=="21"
replace ind2="Utilities" if substr(indnaics,1,2)=="22"
replace ind2="Construction" if substr(indnaics,1,2)=="23"
replace ind2="Manufacturing" if substr(indnaics,1,2)=="31" | substr(indnaics,1,2)=="32" | substr(indnaics,1,2)=="33" | substr(indnaics,1,2)=="3M" 
replace ind2="Wholesale Trade" if substr(indnaics,1,2)=="42"  
replace ind2="Retail Trade" if substr(indnaics,1,2)=="44" | substr(indnaics,1,2)=="4M" | substr(indnaics,1,2)=="45"
replace ind2="Transportation and Warehousing" if substr(indnaics,1,2)=="48" | substr(indnaics,1,2)=="49" 
replace ind2="Information and Communications" if substr(indnaics,1,2)=="51"
replace ind2="Finance, Insurance, Real Estate, and Rental and Leasing" if substr(indnaics,1,2)=="52" | substr(indnaics,1,2)=="53" 
replace ind2="Professional, Scientific, Management, Administrative, and Waste Management Services" if substr(indnaics,1,2)=="54" | substr(indnaics,1,2)=="55" | substr(indnaics,1,2)=="56"
replace ind2="Educational, Health and Social Services" if substr(indnaics,1,2)=="61" | substr(indnaics,1,2)=="62" 
replace ind2="Arts, Entertainment, Recreation, Accommodations, and Food Services" if substr(indnaics,1,2)=="71" | substr(indnaics,1,2)=="72" 
replace ind2="Other Services (Except Public Administration)" if substr(indnaics,1,2)=="81"
replace ind2="Public Administration" if substr(indnaics,1,2)=="92"
replace ind2="Active Duty Military" if substr(indnaics,1,4)=="9281"

gen traded=1 if ind2=="Agriculture, Forestry, Fishing and Hunting"
replace traded=1 if ind2=="Mining"
replace traded=1 if ind2=="Manufacturing"
replace traded=1 if ind2=="Wholesale Trade"
replace traded=0 if missing(traded)
gen nontraded = traded==0

collapse (mean) traded nontraded [pw=perwt], by(occsoc_minor statefip year)
save acs_traded_nontraded_state_occsocminor_year.dta, replace


use ACS3yr_2007_2010_2012.dta, clear
keep if year==2007 

gen occsoc_minor = substr(occsoc,1,3)
drop occsoc

keep if empstat==1

gen ind2="Agriculture, Forestry, Fishing and Hunting" if substr(indnaics,1,2)=="11" 
replace ind2="Mining" if substr(indnaics,1,2)=="21"
replace ind2="Utilities" if substr(indnaics,1,2)=="22"
replace ind2="Construction" if substr(indnaics,1,2)=="23"
replace ind2="Manufacturing" if substr(indnaics,1,2)=="31" | substr(indnaics,1,2)=="32" | substr(indnaics,1,2)=="33" | substr(indnaics,1,2)=="3M" 
replace ind2="Wholesale Trade" if substr(indnaics,1,2)=="42"  
replace ind2="Retail Trade" if substr(indnaics,1,2)=="44" | substr(indnaics,1,2)=="4M" | substr(indnaics,1,2)=="45"
replace ind2="Transportation and Warehousing" if substr(indnaics,1,2)=="48" | substr(indnaics,1,2)=="49" 
replace ind2="Information and Communications" if substr(indnaics,1,2)=="51"
replace ind2="Finance, Insurance, Real Estate, and Rental and Leasing" if substr(indnaics,1,2)=="52" | substr(indnaics,1,2)=="53" 
replace ind2="Professional, Scientific, Management, Administrative, and Waste Management Services" if substr(indnaics,1,2)=="54" | substr(indnaics,1,2)=="55" | substr(indnaics,1,2)=="56"
replace ind2="Educational, Health and Social Services" if substr(indnaics,1,2)=="61" | substr(indnaics,1,2)=="62" 
replace ind2="Arts, Entertainment, Recreation, Accommodations, and Food Services" if substr(indnaics,1,2)=="71" | substr(indnaics,1,2)=="72" 
replace ind2="Other Services (Except Public Administration)" if substr(indnaics,1,2)=="81"
replace ind2="Public Administration" if substr(indnaics,1,2)=="92"
replace ind2="Active Duty Military" if substr(indnaics,1,4)=="9281"

gen traded=1 if ind2=="Agriculture, Forestry, Fishing and Hunting"
replace traded=1 if ind2=="Mining"
replace traded=1 if ind2=="Manufacturing"
replace traded=1 if ind2=="Wholesale Trade"
replace traded=0 if missing(traded)
gen nontraded = traded==0

preserve
collapse (mean) traded nontraded [pw=perwt], by(occsoc_minor statefip)
rename traded tradedst
rename nontraded nontradedst
save acs_traded_nontraded_state_occsocminor.dta, replace
restore

preserve
collapse (mean) traded nontraded [pw=perwt], by(occsoc_minor)
save acs_traded_nontraded_occsocminor.dta, replace
restore


