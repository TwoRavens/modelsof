/* HomescanHouseholdDataPrep.do */
/* Start with household data from Kilts release */
use "$Externals/Calculations/Homescan/Household-Panel.dta", clear

rename panelist_zip_code zip_code

** Number of household heads
gen byte NHeads = cond(male_head_age!=0&female_head_age!=0,2,1)

** Education
	* Mean education of household heads
foreach gender in male female {
	gen `gender'_Educ = .
	replace `gender'_Educ = 6 if `gender'_head_education == 1
	replace `gender'_Educ = 10 if `gender'_head_education == 2
	replace `gender'_Educ = 12 if `gender'_head_education == 3
	replace `gender'_Educ = 14 if `gender'_head_education == 4
	replace `gender'_Educ = 16 if `gender'_head_education == 5
	replace `gender'_Educ = 18 if `gender'_head_education == 6
}
*gen Educ = max(male_Educ,female_Educ)
* Use mean education of two household heads
gen Educ = (male_Educ+female_Educ)/2
replace Educ = male_Educ if female_Educ==.
replace Educ = female_Educ if male_Educ==.
gen lnEduc=ln(Educ)

** Age
* Decode the age categories
foreach gender in male female {
	gen `gender'_head_approxage = .
	replace `gender'_head_approxage = 22 if `gender'_head_age == 1
	replace `gender'_head_approxage = 27 if `gender'_head_age == 2
	replace `gender'_head_approxage = 32 if `gender'_head_age == 3
	replace `gender'_head_approxage = 37 if `gender'_head_age == 4
	replace `gender'_head_approxage = 42 if `gender'_head_age == 5
	replace `gender'_head_approxage = 47 if `gender'_head_age == 6
	replace `gender'_head_approxage = 52 if `gender'_head_age == 7
	replace `gender'_head_approxage = 60 if `gender'_head_age == 8
	replace `gender'_head_approxage = 73 if `gender'_head_age == 9 // This is the mean when observed.
}

* Get specific birth year.
foreach gender in male female {
	gen `gender'_head_birth_year = real(substr(`gender'_head_birth,1,4))
	gen `gender'_head_age1 = panel_year-`gender'_head_birth_year
	replace `gender'_head_age1 = `gender'_head_approxage if `gender'_head_age1==. // When specific birth year not available, use the approximation based on the age category.
}

* Use mean age of two household heads
gen Age = (male_head_age1+female_head_age1)/2
replace Age = male_head_age1 if female_head_age1==.
replace Age = female_head_age1 if male_head_age1==.
gen lnAge = ln(Age)

* Age dummies for age controls
	* Outer bins are based on visual inspection and sample sizes.
gen int AgeInt = round(Age)
replace AgeInt = 23 if AgeInt<23
replace AgeInt = 90 if AgeInt>90

** Get household calorie needs
forvalues m = 1/7 {
	* Get age and gender
	gen member_`m'_age = (panel_year - real(substr(member_`m'_birth,1,4)))
	gen member_`m'_male = cond(inlist(member_`m'_relationship_sex,1,3,5),1,0) if member_`m'_relationship_sex!=.
}

gen age = .
gen Male = .
* Merge calorie needs for household heads
foreach gender in male female {
	replace Male = cond("`gender'"=="male",1,0)
	replace age = `gender'_head_age1
	merge m:1 Male age using "$Externals/Calculations/NutritionFacts/CalorieNeeds.dta", keep(match master) nogen
	rename CalorieNeed `gender'_head_CalorieNeed
	* Determine average calorie need of male/female household heads
	sum `gender'_head_CalorieNeed [aw=projection_factor]
	local `gender'_head_AverageCalorieNeed = r(mean)
}
local HeadAverageCalorieNeed = (`male_head_AverageCalorieNeed'+`female_head_AverageCalorieNeed')/2
	
* Merge calorie needs for other household members
forvalues m = 1/7 {
	replace Male = member_`m'_male
	replace age = member_`m'_age
	merge m:1 Male age using "$Externals/Calculations/NutritionFacts/CalorieNeeds.dta", keep(match master) nogen
	rename CalorieNeed member_`m'_CalorieNeed
}

** Get household size in adult equivalents (technically, household head equivalents)
egen CalorieNeed = rowtotal(*CalorieNeed)
egen NonHeadCalorieNeed = rowtotal(member_?_CalorieNeed)
gen HouseholdSize = NHeads + NonHeadCalorieNeed / `HeadAverageCalorieNeed'
drop *_CalorieNeed age Male


** Children
gen byte Children = cond(age_and_presence_of_children==9,0,1) if age_and_presence_of_children!=.


** Race
gen byte R_White = cond(race==1,1,0)
gen byte R_Black = cond(race==2,1,0)


** Marital status
gen byte Married = cond(marital_status==1,1,0)

** Employment
foreach gender in male female {
	gen `gender'HeadEmployed = cond(`gender'_head_employment!=9,1,0) if `gender'_head_employment!=0
	gen `gender'HeadWorkHours = cond(`gender'_head_employment==1,24,32) if inlist(`gender'_head_employment,1,2,3)
	replace `gender'HeadWorkHours = 40 if `gender'_head_employment==3
	replace `gender'HeadWorkHours = 0 if `gender'HeadEmployed==0
}
foreach var in Employed WorkHours {
	gen `var' = (maleHead`var'+femaleHead`var')/2 if maleHead`var'!=. & femaleHead`var'!=.
	replace `var' = maleHead`var' if femaleHead`var'==.
	replace `var' = femaleHead`var' if maleHead`var'==.
}

** Income
gen NominalIncome = .
replace NominalIncome = 2500 if household_income==3
replace NominalIncome = 6500 if household_income==4
replace NominalIncome = 9000 if household_income==6
replace NominalIncome = 11000 if household_income==8
replace NominalIncome = 13500 if household_income==10
replace NominalIncome = 17500 if household_income==11
replace NominalIncome = 22500 if household_income==13
replace NominalIncome = 27500 if household_income==15
replace NominalIncome = 32500 if household_income==16
replace NominalIncome = 37500 if household_income==17
replace NominalIncome = 42500 if household_income==18
replace NominalIncome = 47500 if household_income==19
replace NominalIncome = 55000 if household_income==21
replace NominalIncome = 65000 if household_income==23
replace NominalIncome = 85000 if household_income==26

** In 2004-2005 and again after 2010, 27 is the highest value. 
* For 2006-2009, we observe more precise high-income categories.
replace NominalIncome = 112500 if household_income==27
replace NominalIncome = 137500 if household_income==28
replace NominalIncome = 175000 if household_income==29
replace NominalIncome = 250000 if household_income==30
replace NominalIncome = 140000 if (panel_year<=2005|panel_year>=2010) & household_income==27 

* replace NominalIncome = 140000 if inlist(household_income,27,28,29,30)==1


** Get real income
rename panel_year year
merge m:1 year using "$Externals/Calculations/CPI/CPI_Annual.dta", keep(match) nogen keepusing(CPI)
rename year panel_year
gen Income = NominalIncome/CPI

gen lnIncome = ln(Income)

** Get current nominal income - i.e. the income for the current panel year. Income as reported in Homescan is for the year that is two years before the current panel year
gen CurrentNominalIncome = .
sort household_code panel_year
replace CurrentNominalIncome = NominalIncome[_n+1] if panel_year[_n+1]==panel_year+2
replace CurrentNominalIncome = NominalIncome[_n+2] if panel_year[_n+2]==panel_year+2

gen CurrentIncome = CurrentNominalIncome/CPI
gen lnCurrentIncome = ln(CurrentIncome)

** Get household average income - the average across all panel years observed.
*bysort household_code: egen HHAvNominalIncome = mean(NominalIncome)
bysort household_code: egen HHAvIncome = mean(Income)
replace HHAvIncome=HHAvIncome/1000

** Get income groups
* Already rounded
foreach income in Nominal {
	gen `income'IncomeGroup = `income'Income/1000
	replace `income'IncomeGroup = 125 if `income'IncomeGroup>=100 // Before 2005 and after 2010, this is all that we observe anyway. 100k is about the 90th percentile.
	replace `income'IncomeGroup = 6.5 if `income'IncomeGroup<10
	replace `income'IncomeGroup = 12.5 if `income'IncomeGroup>=10&`income'IncomeGroup<15
}
* Not rounded
foreach income in HHAv {
	gen `income'IncomeGroup = `income'Income //
	replace `income'IncomeGroup = 6.5 if `income'IncomeGroup<10
	* Round to midpoint of every $5k between 10k and 50k
	replace `income'IncomeGroup = floor(`income'IncomeGroup/5)*5+2.5 if `income'IncomeGroup>=10&`income'IncomeGroup<50
	* Round to midpoint of every $10k between 50k and 60k
	replace `income'IncomeGroup = 55 if `income'IncomeGroup>=50&`income'IncomeGroup<60
	replace `income'IncomeGroup = 65 if `income'IncomeGroup>=60&`income'IncomeGroup<70
	replace `income'IncomeGroup = 85 if `income'IncomeGroup>=70&`income'IncomeGroup<100
	replace `income'IncomeGroup = 125 if `income'IncomeGroup>=100&`income'IncomeGroup!=.
}

** Income quartile and "SES" quartile (residual of controls)
xtile byte IncomeQuartile = HHAvIncome [aw=projection_factor], nq(4)

reg HHAvIncome $SESCtls i.panel_year [pw=projection_factor], robust cluster(household_code)
predict IncomeResid, residuals
xtile byte IncomeResidQuartile = IncomeResid [aw=projection_factor], nq(4)


*** First year in zip code
bysort household_code zip_code: egen int FirstYearInZip = min(panel_year)

keep household_code panel_year projection_factor projection_factor_magnet ///
	zip_code fips_state_code fips_county_code dma_code region_code ///
	Income lnIncome NominalIncome NominalIncomeGroup HHAvIncomeGroup HHAvIncome CurrentIncome lnCurrentIncome CurrentNominalIncome IncomeQuartile IncomeResid IncomeResidQuartile ///
	Educ lnEduc Age lnAge AgeInt Children R_* Married Employed WorkHours CalorieNeed household_size HouseholdSize FirstYearInZip NHeads


*** Label variables
label var lnIncome "ln(Household income)"
label var lnCurrentIncome "ln(Household income (two-year lead))"
label var HHAvIncome "Household average income"
label var R_White "1(White)"
label var R_Black "1(Black)"
label var lnEduc "ln(Years education)"
label var Children "1(Have children)"
label var Married "1(Married)"
label var WorkHours "Weekly work hours"
label var CalorieNeed "Daily household calorie need"
label var region_code "Census division"
label var household_size "Household size"
label var HouseholdSize "Household size"
label var FirstYearInZip "First year in zip code"

/* Merge other datasets */
*** PanelViews
	* Don't merge on panel_year: apply the panelviews results to all years of the same household
merge m:1 household_code using "$Externals/Data/Nielsen/Homescan/PanelViews.dta", ///
	keep(match master) nogen keepusing(svy_health_importance svy_health_knowledge BMI Diabetic)

	
	** Make knowledge scores mean 0, standard deviation 1 across household x year observations. (Could do this across households but want it to look clean in the summary stats table)
	foreach var in svy_health_knowledge svy_health_importance {
		sum `var' [aw=projection_factor]
		replace `var' = (`var'-r(mean))/r(sd)
	}

*** Get county ID and Commuting Zone
gen long state_countyFIPS = fips_state_code*1000+fips_county_code
include Code/DataPrep/Geographic/FixCountyFIPS.do
merge m:1 state_countyFIPS using "$Externals/Calculations/Geographic/CountytoCZCrosswalk.dta", nogen keep(match master) keepusing(cz cz1990)
	
*** Zip code income and education
merge m:1 zip_code using "$Externals/Calculations/Geographic/Z_Data.dta", keepusing(Z_Income Z_lnIncome ZipEduc ZiplnEduc ZipCollege ZipCentroid_lat ZipCentroid_lon) keep(match master) nogen

*** Census tract
merge m:1 household_code panel_year using "$Externals/Calculations/Homescan/HouseholdCensusTracts.dta", keep(match master) nogen ///
	keepusing(gisjoin UnreliableTractData)
gen byte HaveTract = cond(gisjoin!="",1,0) // Takes value 1 if we observe it

** Impute tract using prior/next year if in same zip
	* Note that we have less coverage in 2012-2016 because the original tract data don't cover those years.
sort household_code panel_year
replace gisjoin = gisjoin[_n-1] if household_code==household_code[_n-1] & zip_code==zip_code[_n-1]&missing(gisjoin)==1&UnreliableTractData!=1 // UnreliableTractData!=1 means that if we already made gisjoin missing in PrepHouseholdCensusTracts.do, we won't roll forward or backward the Census tracts from other years.
gsort household_code -panel_year
replace gisjoin = gisjoin[_n-1] if household_code==household_code[_n-1] & zip_code==zip_code[_n-1]&missing(gisjoin)==1&UnreliableTractData!=1

gen byte HaveOrImputeTract = cond(gisjoin!="",1,0) // If HaveOrImputeTract==0, then we are actually using zip data instead of tract data.


** Merge Census tract covariates
merge m:1 gisjoin using "$Externals/Calculations/Geographic/Tr_Data.dta", keep(match master) nogen ///
	keepusing(TractMedIncome TractlnMedIncome TractEduc TractlnEduc TractCollege TractCentroid_lat TractCentroid_lon)

*** Impute Tract data with Zip data if missing
replace TractMedIncome = Z_Income if TractMedIncome==.
replace TractlnMedIncome = Z_lnIncome if TractlnMedIncome==.
foreach var in Educ lnEduc College Centroid_lat Centroid_lon {
	replace Tract`var' = Zip`var' if Tract`var'==.
}

** Get a CTractGroup variable
gen CTractGrouptemp = cond(gisjoin!="",gisjoin,string(zip_code))
egen CTractGroup = group(CTractGrouptemp)
drop CTractGrouptemp

/*
** Get a unique location ID variable
	* Comment this out because we need the location IDs to be stable, as they are connected to the drivetime data. Do not re-run this.
	* This is almost like CTractGroup but appears to be different
save temp.dta, replace
collapse (first) household_code, by(TractCentroid_lat TractCentroid_lon)
drop household_code
sort TractCentroid_lat TractCentroid_lon
egen long HMS_Location_ID = group(TractCentroid_lat TractCentroid_lon)
drop if HMS_Location_ID==.
save Calculations/Homescan/HMS_Location_ID.dta, replace
erase temp.dta
*/
** Merge the unique location ID variable.
merge m:1 TractCentroid_lat TractCentroid_lon using "$Externals/Calculations/Homescan/HMS_Location_ID.dta"
drop if _m==2 // temporary while we reconstruct these
assert _m==1|_m==3 // There are 2901 missing observations for 2004-2013, all of which are missing TractCentroid_lat/lon, so this is fine. There are another 5485 missing observations for 2014 and 2015, about 4.46 percent of sample. Could re-run the drivetimes if adding additional years.
drop _m


/* Get In-Sample Mover variables */
gen int zip3 = floor(zip_code/100)

* Moved = 1 in year t if you are in a different location than you were at the end of t-1.
	* Note: Per Hunt's conversations with Nielsen and Art Middlebrooks September 2017, the location variables are valid for the END of the panel_year. This is different from the income and other demographic variables, which are from a survey given late in the PREVIOUS panel year.
sort household_code panel_year
gen byte Moved = cond(household_code==household_code[_n-1] & panel_year==panel_year[_n-1]+1 & CTractGroup!=CTractGroup[_n-1] & CTractGroup!=.&CTractGroup[_n-1]!=. , 1,0)

gen Oldlat = TractCentroid_lat if Moved==1
gen Oldlon = TractCentroid_lon if Moved==1
gen Newlat = TractCentroid_lat[_n-1] if Moved==1
gen Newlon = TractCentroid_lon[_n-1] if Moved==1

geodist Oldlat Oldlon Newlat Newlon, miles gen(MoveDistance) // a small number of these are MoveDistance=0 because you can move zips but still be in the same tract.
drop Oldlat Oldlon Newlat Newlon

** Move`areatype'Year = 1 if you moved more than ten miles between the beginning and end of year t, and we see you in year t-1 and t
	* You could in principle move more than 10 miles but stay in the same zip, but then we impute the same local RMS environment for you anyway.
	* Due to unbalanced panel, you may move but MoveYear=0 if we don't know the year when you moved.
foreach areatype in Z Z3 Ct CZ St {
	include Code/DataPrep/DefineGeonames.do
	sort household_code panel_year
	gen byte Move`areatype'Year = cond(household_code==household_code[_n-1] & panel_year==panel_year[_n-1]+1 ///
		& `geoname'!=`geoname'[_n-1] & `geoname'!=.&`geoname'[_n-1]!=. & MoveDistance>10 , 1,0) // This also accepts MoveDistance==.; there are a couple hundred moves where we don't know the centroids and so effectively assume that the move was more than 10 miles.
}



/* Get Birth Mover variables 
** YearsCurrentSt is years in current state. 
	* It is the original PanelViews question for 2008, then modified for earlier and later years as long as there was no move. 
gen int YearsCurrentSt = years_currstate + (panel_year-2008) // this could be negative, but if negative it will be made out of sample in the code just below.

** Make BirthMoverHH_* missing if not valid data
foreach def in All BDG {
		* Out of sample if per PanelViews, the household has not moved yet.
		replace BirthMoverHH_`def' = . if YearsCurrentSt<0

		* Out of sample if the household is in a different state than their September 2008 reported state. (Mostly people who move after 2008.)
		replace BirthMoverHH_`def' = . if state_curr_fips!=fips_state_code
		* NB we are keeping households that move zips within the state. There is no way to identify and drop all of these households given that they may have moved around the state before entering the Homescan panel.
}
*/

compress
saveold "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta",replace



