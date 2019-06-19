set mem 10000M
local fileName = "PrepareFiles2"
log using `fileName'.log, replace

local quotesFile12 = "Data/detailedQuotesDec"
local quotesFile11 = "Data/detailedQuotesNov"
local geoRegionFile = "Data/geoRegionZipcode.dta"


***Code Additional Details of plans
use PrivateData/NovDec09AllChoices.dta
	drop plantitle
	rename tierChosen plan
	gen plantitle=plantitleChosen
	bysort plantitle: keep if _n==1
	sort plantitle
	
	tempfile firsttemp
	save `firsttemp'

use PrivateData/NovDec09AllChoices.dta
	sort plantitle
	merge m:1 plantitle using `firsttemp'
	keep if _merge==3
	drop _merge
	sort plantitle
	tempfile temp2
	save `temp2'

***Merge in some detail of plans
use `quotesFile12', clear
	drop zipcode age_self age_spouse_ familysize
	append using `quotesFile11'
	
	bysort plantitle: keep if _n==1
	
	replace plantitle=itrim(plantitle)
	replace plantitle=ltrim(plantitle)
	replace plantitle=rtrim(plantitle)
	replace plantitle="Select Care 2000" if plantitle=="FCHP Select Care"
	replace plantitle="Direct Care -  PS 2000 with Rx" if plantitle==" FCHP Direct Care"
	sort plantitle
	keep plantitle deductible-hosp hospital_stay
merge 1:m plantitle using `temp2'
drop _merge
***Characteristics of Plans
	*gen deduct_level=0 if deductible=="None/None"
	*replace deduct_level=250 if deductible=="$250 per plan year/$500 per plan year"
	*replace deduct_level=750 if deductible=="$750/$1,500"
	*replace deduct_level=1000 if deductible=="$1,000/$2,000"
	*replace deduct_level=1750 if deductible=="$1,750/$3,500"
	*replace deduct_level=2000 if deductible=="$2,000/$4,000"
	*gen ided=0 if deduct_level==0
	*replace ided=250 if deduct_level==250
	*replace ided=750 if deduct_level==750
	*replace ided=1000 if deduct_level==1000
	*replace ided=1750 if deduct_level==1750
	*replace ided=2000 if deduct_level==2000
	*gen doc_co=15 if doctor=="$15"
	*replace doc_co=20 if doctor=="$20"
	*replace doc_co=25 if doctor=="$25" | doctor=="$25 after deductible" | doctor=="$25 copay up to 3 medical care office visits per individual (or 6 per family); next visits are subject to the deductible; then 20% co-insurance thereafter"
	*replace doc_co=30 if doctor=="$30"
	*replace doc_co=40 if doctor=="$40"

	gen tt=substr(rx,1,15)
	gen tier1=10 if tt=="$10 / $25 / $45" | tt=="$10 / $30 / 100" | tt=="$10 after Rx de"| tt=="$10 after Rx de"
	replace tier1=20 if tt=="$20 after Rx de"
	replace tier1=15 if tier1==.
	*gen hcopay=hosp>1 

	egen caseid=group(member_no tx_eff_date)
	gen female=gender=="F"
	gen age=1 if age_self<30
	replace age=2 if age_self >=30 & age_self <35
	replace age=3 if age_self >=35 & age_self <40
	replace age=4 if age_self >=40 & age_self <45
	replace age=5 if age_self >=45 & age_self <50
	replace age=6 if age_self >=50 & age_self <55
	replace age=7 if age_self >=55
	drop if age==.
	
	gen bronze=1 if plan=="BRONZE" | plan=="BRONZE PLUS"
	gen silver=1 if plan=="SILVER" | plan=="SILVER PLUS" | plan=="SILVER SELECT"
	replace plan="BRONZE" if plan=="BRONZE PLUS"
	
	replace bronze=0 if bronze==.
	replace silver=0 if silver==.

	gen tg=1 if bronze==1
	replace tg=2 if silver==1
	replace tg=3 if tg==.
	sort zipcode

	drop if zipcode ==.
	sort zipcode
	merge m:1 zipcode using `geoRegionFile'
	gen mkt=geoRegion
	gen b=substr(plan,1,1)

	tempfile temp4
	save `temp4', replace
	sort b
	egen pt=group(plantitle)
	replace predictedPremium=predictedPremium/100
	*replace income=income/100
	*replace ided=ided/100
	*replace doc_co=doc_co/100
	*gen iprem=income*predictedPremium
	xi i.carrierOpt i.plan 
	tab carrierOpt
	tab plan
	replace plan=substr(plan,1,3)

	gen pp=-predictedPremium	
	
	
	gen band1=(age_self==29 | age_self==30 | age_self==31 | age_self==34 | age_self==35 | age_self==36 | age_self==39 | age_self==40 | age_self==41 | age_self==44 | age_self==45 | age_self==46 | age_self==49 | age_self==50 | age_self==51 | age_self==54 | age_self==55 | age_self==56)
	egen mean_age=mean(age_self)
	replace age_self=age_self-mean_age

***Save for future use	
save PrivateData/ProcessedData.dta, replace

log close
