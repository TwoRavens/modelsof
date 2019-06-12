/* ImportCalorieNeeds.do */
* This file imports and prepares calorie needs from the dietary guidelines: 
* https://health.gov/dietaryguidelines/2015/guidelines/appendix-2/#table-a2-1

* We assume that 25% are sedentary, 50% moderately active, and 25% active based roughly on 2013 BRFSS data:
	* https://nccd.cdc.gov/NPAO_DTM/IndicatorSummary.aspx?category=71&indicator=34&year=2013&yearId=17

insheet using $Externals/Data/NutritionFacts/USDA/CalorieNeeds.csv, comma nonames clear
rename v1 AgeBracket
gen Male = cond(_n<=33,1,0)
destring v2, gen(Cal_Sedentary) force ignore(",")
destring v3, gen(Cal_Moderately) force ignore(",")
destring v4, gen(Cal_Active) force ignore(",")
keep AgeBracket Male Cal_*
drop if Cal_Sedentary==.

** Get one weighted CalorieNeed
gen CalorieNeed = 0.25 * Cal_Sedentary + 0.5 * Cal_Moderately + 0.25 * Cal_Active


save $Externals/Calculations/NutritionFacts/CalorieNeedsTemp.dta, replace

clear
set obs 121
gen age = _n-1
gen AgeBracket = ""
replace AgeBracket = string(age) if age<=18
replace AgeBracket = "2" if age<2
replace AgeBracket = "19-20" if age>=19&age<=20

replace AgeBracket = "21-25" if age>=21&age<=25
replace AgeBracket = "26-30" if age>=26&age<=30

replace AgeBracket = "31-35" if age>=31&age<=35
replace AgeBracket = "36-40" if age>=36&age<=40

replace AgeBracket = "41-45" if age>=41&age<=45
replace AgeBracket = "46-50" if age>=46&age<=50

replace AgeBracket = "51-55" if age>=51&age<=55
replace AgeBracket = "56-60" if age>=56&age<=60

replace AgeBracket = "61-65" if age>=61&age<=65
replace AgeBracket = "66-70" if age>=66&age<=70

replace AgeBracket = "71-75" if age>=71&age<=75
replace AgeBracket = "76 and up" if age>=76

saveold $Externals/Calculations/NutritionFacts/CalorieNeeds.dta, replace

append using $Externals/Calculations/NutritionFacts/CalorieNeeds.dta, gen(Male)

merge m:1 AgeBracket Male using $Externals/Calculations/NutritionFacts/CalorieNeedsTemp.dta, nogen keepusing(CalorieNeed)
drop AgeBracket

sort Male age 
compress
saveold $Externals/Calculations/NutritionFacts/CalorieNeeds.dta, replace


erase $Externals/Calculations/NutritionFacts/CalorieNeedsTemp.dta

