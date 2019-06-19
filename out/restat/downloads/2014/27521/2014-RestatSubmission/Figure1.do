conren style 3

local fileName = "Figure1"
capture mkdir `fileName'
capture ! chmod 750 `fileName'

log using `fileName'.log, replace 

set mem 1400m
set matsize 800

***Nov-Dec 2009 Enrollment
	use PrivateData/NovDec09AllChoices.dta
	assert age_self !=.
	egen planIdNum = group(plantitleChosen)

	gen bronze=1 if tierChosen=="BRONZE" | tierChosen=="BRONZE PLUS"
	gen silver=1 if tierChosen=="SILVER" | tierChosen=="SILVER PLUS" | tierChosen=="SILVER SELECT"
	gen gold=1 if tierChosen=="GOLD"
	replace bronze=0 if bronze==.
	replace silver=0 if silver==.
	replace gold=0 if gold==.

	
preserve	
clear
***We want to merge in plan level information: price at age 30  in your zip code
	use WorkingData/NovPredictions.dta
	keep if age_self==30
	drop age_self
	rename plantitle plantitleChosen
	rename predictedPremium premiumAge30
	keep plantitleChosen zipcode premiumAge30
	sort plantitleChosen zipcode
	tempfile NovAge30
	save `NovAge30'
restore	
	sort plantitleChosen zipcode
	merge plantitleChosen zipcode using `NovAge30'
	tab _merge
	drop if _merge ==2
	assert _merge ==3
	
	keep if plantitle == plantitleChosen
	collapse (mean) predictedPremium (mean) premiumAge30,by(age_self)
	list
	
	
sort age_self
rename predictedPremium avgSpendingAct
rename premiumAge30 avgSpendingAge30
save `fileName'/Figure2BasisPartA.dta, replace
clear

***Now, the last thing we need is nov prices by age
	use WorkingData/NovPredictions.dta
	collapse (mean) predictedPremium ,by(age_self)
	save `fileName'/Figure2BasisPartB.dta, replace
merge 1:1 age_self using `fileName'/Figure2BasisPartA.dta
rename predictedPremium avgListPrice
drop if _merge ==1
drop _merge
set scheme s1mono

twoway (connected avgListPrice age,sort  lcolor(black) lwidth(medthick) lpattern(solid) mcolor(black) msymbol(circle))(connected avgSpendingAge30 age,sort  lcolor(gray) lwidth(medthick) lpattern(solid)  mcolor(gray) msymbol(triangle) ), legend(on order(1 "Average List Premium" 2 "Average Spending at Age 30 Prices")) ytitle("Monthly Premium in $") xlabel(25(5)65) xtitle("Age") 
graph save `fileName'/Figure2.gph, replace

log close

