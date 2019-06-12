* Run on Stata 13 for Mac (OS 9)
* June 3, 2016


*** Set Path
* cd "..."

use "firm_industry_country.dta", replace


** Keep firms that respond to the Tax Compliance question
** Non-Response is assessed in Appendix Materials
** Keep the filter activated unless otherwise stated
drop if taxcomp == . 


* Winsorize based on Labor
	sort digit2
	bysort digit2: egen max=pctile(labor), p(99)
	bysort digit2: egen min=pctile(labor), p(1) 
	bysort digit2: gen winso_labor = labor if (labor>min & labor<max)
	drop max min
	sum labor winso_labor
	drop if winso_labor == . 
	

/* FIRM-LEVEL VARIABLES */
	
* Government Ownership
gen government = 1 if public_share>50 & public_share<= 100
replace government = 0 if public_share>=0 & public_share<=50

gen noiso = 0 if iso == 1
replace noiso = 1 if iso == 0

gen lnage = ln(age)
gen lnfirmlabor = ln(labor)
gen lnexportshare = ln(1+exportshare)
gen ln_firm_age = ln(age)
gen ln_labor = ln(labor)


**************************
* COUNTRY-LEVEL VARIABLE
**************************

* Total Population 
gen ln_tot_pop = ln(tot_pop)

* Low Fiscal Capacity
gen lowfc = -1*taxstaff

**************************
* INDUSTRY LEVEL CONTROLS
**************************

* Labor 
bysort idc digit2: egen tot_labor = total(winso_labor)

* Productivity
bysort idc digit2: egen avgiso = mean(iso)
gen obsolete = 1 - avgiso
	
* Mining Sector
gen mining = 1 if digit2<15
replace mining = 0 if digit2>=15

* Public Share
bysort idc digit2: egen n_government = total(government)
bysort idc digit2: gen n_firms = _N
gen gov_owner_share = 100*(n_government/n_firms)

bysort idc digit2: egen avgexport = mean(exportshare) 	
bysort idc digit2: egen avgage = mean(age) 	

* Log Transformations
gen lntariff = ln(1+tariff)
gen lntotlabor = ln(tot_labor)
gen lnavgexport = ln(1+avgexport)
gen lnavgage = ln(avgage)
gen lngov_owner_share = ln(1+gov_owner_share)
	
* Number of Competitors
bysort idc digit2: egen avgcompetitors = mean(competitors)
drop if avgcompetitors == .


* Dep. Var v1:  Weighted Tax Compliance
gen weight = winso_labor/tot_labor
gen tool = weight*taxcomp
bysort idc digit2: egen wavgcomp = total(tool)
drop tool

* Dep. Var v2: Non-Weighted Tax Compliance
bysort idc digit2: egen avgcomp = mean(taxcomp)

* Normalize dep vars
gen uwtaxcomp= avgcomp/100
gen wtaxcomp = wavgcomp/100


*****************************************
* CREATE TWO-DIGIT INDUSTRY LEVEL DATA
*****************************************

* Keep industry averages	
bysort idc digit2: gen cases = _n
keep if cases == 1

* Identifier
sort country digit2
gen industry_id = _n
sort industry_id
order industry_id idc country, first

saveold "industry_country.dta", replace	


**********************************
* DATA FOR HLM analysis in R 
**********************************

* Industry-level variables
use "industry_country.dta", clear
keep country idc wtaxcomp uwtaxcomp region mining lnavgexp avgcompetitors lnavgage lntotlabor gov_owner_share free_media ln_tot_pop obsolete tariff
sort country idc
saveold "industry_level_data_for_HLM_models.dta", replace


* Country-level variables
use "industry_country.dta", clear
sort idc country
bysort idc: gen case = _n
keep if case == 1
keep idc lowfc country taxy
rename lowfc lowfc_32
sort country
saveold "country_level_data_for_HLM_models.dta", replace


*************************************************
* DATA FOR SCATTER PLOTS
*************************************************

use "industry_country.dta", clear
bysort country: gen id = _n
keep if id == 1
sum lowfc, detail
saveold  "data_for_scatter_plots.dta", replace


**********************************
* DATA WITHOUT OUTLIERS
**********************************

use "industry_country.dta", clear

* No outliers
rename lowfc lowfc_industry
drop if industry_id==315 
drop if industry_id==371
sort country digit2
saveold "industry_country_no_outliers.dta", replace	


