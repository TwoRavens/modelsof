conren style 3
local fileName = "PrepareFiles1"
log using `fileName'.log, replace 
capture mkdir WorkingData
capture mkdir PrivateData
local PrivateDataLocation = "enroll.dta"

set mem 1500m

***This file has two parts:
***Part 1: Create detailed premium quotes
***Part 2: Create choice menu and choices from transcation data

***Part 1

foreach monthNum in 11 12{
	if `monthNum' == 11{
		local month = "Nov"
		local dateString = "01Nov2009"
	}
	if `monthNum' == 12{
		local month = "Dec"
		local dateString = "01Dec2009"
	}


	use Data/premiumQuotesNovDec2009.dta
	
	destring premium, ignore("$,") replace

	***Focus on individual market only
		keep if familysize ==1 & year == 2009 & month == `monthNum'
	
	***We have a plan title recode issue: 
		 replace plantitle ="Select Care 2000" if deductible =="$2,000/$4,000" & plantitle =="FCHP Select Care"
		 replace plantitle ="Select Care 500" if deductible =="$500/$1,000"   & plantitle =="FCHP Select Care"
		 replace plantitle ="Select Care - Premier Value" if deductible =="None/None"     & plantitle =="FCHP Select Care"
							
		 replace plantitle ="Direct Care PS 500" if deductible == "$500/$1,000" & plantitle =="FCHP Direct Care"
		 replace plantitle ="Direct Care -  PS 2000 with Rx" if deductible =="$2,000/$4,000"   & plantitle =="FCHP Direct Care"
	
		 ***SHOULD BE NO DUPLICATES
		 duplicates report zipcode age_self plantitle
		 
		 
***Now, we need to make a series of synthetic base datasets
tempfile base
save `base'

gen n =1 
collapse (count) n,by(age_self)
drop n
save WorkingData/age, replace
clear
use `base'
gen n=1
collapse (count) n,by(zipcode)      
drop n
save WorkingData/zip, replace
clear
use `base'
gen n=1
collapse (count) n,by(plantitle insurername)      
drop n
save WorkingData/plantitle, replace
clear

***Now merge and create a very large dataset
use WorkingData/zip
cross using WorkingData/age
	cross using WorkingData/plantitle
	count
	***We are creating placeholder observations, for which we will predict values of premiums.
	***This indicator says it is a placeholder observation, as opposed to an actual premium quote. 
	gen predictedDataset = 1

save WorkingData/crossedDataset`month', replace



**To the placeholder dataset, we will append actual premium quotes.	
	***Now, go back to base
		clear
		use `base'
	***Identify detailed zipcode: these are the people we want to identify age patterns off of
		gen detailZip = 0
		replace detailZip  = 1 if zipcode == 1020
		replace detailZip  = 1 if zipcode == 1240
		replace detailZip  = 1 if zipcode == 1604
		replace detailZip  = 1 if zipcode == 1824
		replace detailZip  = 1 if zipcode == 1923
		replace detailZip  = 1 if zipcode == 2124
		replace detailZip  = 1 if zipcode == 2130
		replace detailZip  = 1 if zipcode == 2360
		replace detailZip  = 1 if zipcode == 2459
		replace detailZip  = 1 if zipcode == 2474
		replace detailZip  = 1 if zipcode == 2601
		
		tab zipcode if detailZip==1,gen(_IdetailZip)
		
	***Now append the crossed dataset
		***Need to shink variable list
		assert month ==`monthNum' & year ==2009 & familysize ==1
		keep zipcode detailZip _Idetail* age_self plantitle insurername premium 
		append using WorkingData/crossedDataset`month'
		
	***REGRESSION VARIABLES: Create indicators for age group
		tab plantitle,gen(_Iplantitle)
	
		gen age2529 = 1 if age_self >=25 & age_self <=29
		gen age3034 = 1 if age_self >=30 & age_self <=34
		gen age3539 = 1 if age_self >=35 & age_self <=39
		gen age4044 = 1 if age_self >=40 & age_self <=44
		gen age4549 = 1 if age_self >=45 & age_self <=49
		gen age5054 = 1 if age_self >=50 & age_self <=54
		gen age5564 = 1 if age_self >=55 & age_self <=64
		***Should be precisely on non missing var per observation
			egen Nnonmiss = rownonmiss(age2529 age3034 age3539 age4044 age4549 age5054 age5564)
			assert Nnonmiss ==1
			drop Nnonmiss
			foreach var in age2529 age3034 age3539 age4044 age4549 age5054 age5564{
				replace `var'= 0 if `var'==.
			}
			egen rowtotal = rowtotal(age2529 age3034 age3539 age4044 age4549 age5054 age5564)
			assert rowtotal ==1
			drop rowtotal
		****Need to get each plan/zipcode's age 30 premoum
			***Gets a premium for each plan/zip combo
				***If a plan is not offerred it is missing in this 
			gen age30PremiumTemp = premium if age_self == 30
				replace age30PremiumTemp = 0 if  age_self != 30
			egen age30PremiumZip=max(age30PremiumTemp) ,by(plantitle zipcode)
			
			***Now, age30Premium will be zero for plans that are not offered in a zipcode
			count if age30PremiumZip==.
			count if age30PremiumZip ==0
			
			sum age30PremiumZip, detail
			tabstat age30PremiumZip, by(plantitle) stats(mean sd)
			

			***This will create an indicator for whether the plan-zip observation has an age30 quote
			gen has30quoteTemp = 1 if age_self ==30 & premium!=.
				replace has30quoteTemp = 0 if has30quoteTemp !=1
			egen has30quote=max(has30quoteTemp) ,by(plantitle zipcode)
			sum age30PremiumZip if has30quote ==0,detail
			sum age30PremiumZip if has30quote ==1, detail
			replace age30PremiumZip=. if has30quote ==0
			
			sum age30PremiumZip, detail
			tabstat age30PremiumZip, by(plantitle) stats(mean sd)
			
			
		***Now, age gradient proportional to premium. So interact age vars with age30 premium
			foreach var in age2529 age3034 age3539 age4044 age4549 age5054 age5564{
				gen `var'Xp30= `var'*age30PremiumZip
			}
			count if age2529Xp30 ==. & age30PremiumZip!=.
****Here, I merge in geographic coding
	sort zipcode
	merge zipcode using Data/geoRegionZipcode.dta
	assert _merge==3
	drop _merge
		
 	
	***Now, We Can run a regression model
		***We estimate the coefficients based on actual observations (detail zip)
		***And then predict to the placeholder dataset
		local ifCondit = "detailZip==1"
		local age = "age3034 age3539 age4044 age4549 age5054 age5564"
		local ageInteracts ="age2529Xp30  age3034Xp30  age3539Xp30  age4044Xp30  age4549Xp30  age5054Xp30  age5564Xp30"
		reg premium age30PremiumZip `age' _Iplantitle* if `ifCondit'
		reg premium age30PremiumZip `age' `ageInteracts' _Iplantitle* if `ifCondit'
	
		predict premiumHat
		gen residuals = premiumHat - premium if premium !=.
		
		reg premiumHat premium
		
	***Now, file to save
		***We want only the predicted observations, not the actual
		keep if premium ==.
		keep zipcode age_self plantitle insurername  premiumHat geoRegion
		rename premiumHat predictedPremium
		compress
		sort age_self zipcode
		save WorkingData/`month'Predictions.dta, replace
		capture !rm WorkingData/crossedDataset`month'.dta.gz
		capture !gzip WorkingData/crossedDataset`month'.dta
***End predictions
}

****Part 2: Now, having created the estimated quotes, we go to creating datasets for individual choice		
		
foreach monthNum in 11 12{
	if `monthNum' == 11{
		local month = "Nov"
		local dateString = "01Nov2009"
	}
	if `monthNum' == 12{
		local month = "Dec"
		local dateString = "01Dec2009"
	}
	
	clear
	use `PrivateDataLocation'
	drop c27 c25 c29 c28 esign_ variabl0 cancel_reason 
	format %12.0f member_no
	***Look at people who bought (transaction: ADD) with an anniversary date on the first of the month
	keep if tx_abbr=="ADD" 
	keep if annv_date == date("`dateString'","DMY")
	***Drop YAP and Medicare
	keep if age >26
	drop if age > 64
	rename age age_self

	***Select only single individual plans
	keep if dep_count==1
	rename carrier_plan_name plantitle
	rename m_zip zipcode
	gen ActualObservation =1

	***Recode plan title to match with those in the quotes datafile
		replace plantitle = "Harvard Pilgrim Best Buy HMO 1000" if plantitle =="Best Buy HMO 1000"
		replace plantitle = "Harvard Pilgrim Core Coverage 1750" if plantitle =="Core Coverage 1750"
		replace plantitle = "HMO Blue Basic Value" if plantitle =="HMO Blue Basic Value with pharmacy coverage"
		replace plantitle = "HMO Blue Value with Basic Rx" if plantitle =="HMO Blue Value (with BasicRx)"
		
		replace plantitle = "HNE EssentialMax" if plantitle =="HNE Essential Max"
		replace plantitle = "HNE WisePlus" if plantitle =="HNE Wise Plus"
		replace plantitle = "Harvard Pilgrim Tiered Copayment HMO 30" if plantitle =="Tiered Copayment HMO 30"
		
		replace plantitle ="Direct Care PS 500" if plantitle =="Direct Care -  PS 500"
		replace plantitle ="Select Care 500" if plantitle =="Select Care -  PS 500"
		replace plantitle= "Select Care 2000" if plantitle=="Select Care - PS 2000/500 with Rx"
		replace plantitle = "Harvard Pilgrim Tiered Copayment HMO 15" if plantitle == "Tiered Copayment HMO 15"

	***Record the actual premium paid	 
		gen premiumPaid = mo_prem
		replace premiumPaid= . if premiumPaid==0 
	rename plantitle plantitleChosen
	
	sort age_self  zipcode  
	
	***Mark potential duplicates: two adds on the same effective date may sometimes have multiple records with different tx_effdate
		egen uniqueObs = tag(age_self zipcode plantitleChosen member_no)
		keep if uniqueObs==1
		drop uniqueObs

	joinby age_self zipcode using WorkingData/`month'Predictions.dta

	gen choseThisPlan =1 if plantitle==plantitleChosen
		replace choseThisPlan =0 if plantitle!=plantitleChosen
	egen personTag = tag(member_no)


	rename carrier carrierChosen
	rename insurername carrierOpt
	rename plan tierChosen
	drop rx  e_sign type_add_reason abbr_cancel_reason esign_date manual_app_dt mo_payable report_date tx_amt add_type
	
	label data "Nov 2009 enrollees. Option set format. one observation per person-planoption."
	save PrivateData/`month'AllChoices.dta, replace
	keep if add_reason =="05-NEW BUSINESS"
	save PrivateData/`month'FirstChoices.dta, replace
}	


***Nowappend Nov data set	
	use PrivateData/NovFirstChoices.dta
	append using PrivateData/DecFirstChoices.dta
	label data "Nov and Dec 2009 NEW enrollees. Option set format. one obs per person-planoption."
	save PrivateData/NovDec09FirstChoices.dta, replace
	clear

	use PrivateData/NovAllChoices.dta, replace
	append using PrivateData/DecAllChoices.dta
	label data "Nov and Dec 2009 enrollees, including renewals. Option set format. one obs per person-planoption."
	save PrivateData/NovDec09AllChoices.dta, replace
log close
