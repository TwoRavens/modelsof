
/*do file name: AnalyzeLandData.do,

Use cleaned land data merged with city characteristics to 
do cross city regression analysis
Created by: Junfu Zhang
Last modified on 4/28/2016

*/

clear matrix


log using AnalyzeLandData, t replace

set rmsg on
set more off
set matsize 800
set memory 1g
set varlabelpos 15


use CleanedLandData.dta


/*part 5: regress land price on FAR */
/*model: regress land price level on maximum FAR regulation*/
xi: areg lnlandprice i.year lnmaxfar, a(city) cl(city)
xi: areg lnlandprice i.year lnmaxfar if residential == 1, a(city) cl(city)

xi: areg lnlandprice i.year lnmaxfar, a(locationcode) cl(locationcode)
xi: areg lnlandprice i.year lnmaxfar residential commercial, a(locationcode) cl(locationcode)
xi: areg lnlandprice i.year lnmaxfar if residential == 1, a(locationcode) cl(locationcode)
xi: areg lnlandprice i.year lnmaxfar if commercial == 1, a(locationcode) cl(locationcode)

ge district_year = locationcode*year
xi: areg lnlandprice lnmaxfar if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar if commercial == 1, a(district_year) cl(locationcode)

//Check the effects of minimun FAR            *** Footnote 13 ***
gen lnminfar=log(minfloorlotratio)
xi: areg lnlandprice lnminfar if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnminfar if commercial == 1, a(district_year) cl(locationcode)


//Count number of cities & districts
sort city district
count if city != city[_n-1]
count if district != district[_n-1]

/***************************************************************************************************/
//Check whether the use of "two stage auction" (挂牌) makes a difference
//Check whether noncompetitive sales make a difefrence
count if typeofsale == "挂牌"
ge TwoStageAuction = 0
replace TwoStageAuction = 1 if typeofsale == "挂牌"

replace startingprice = "." if startingprice == "-"
destring startingprice, replace
destring sellingprice, replace

ge premium = sellingprice/startingprice
count if premium >= 1.00
count if premium == 1.00
count if premium < 1.00

sum premium if premium > 1.00 
sum premium if premium > 1.00 & residential == 1
sum premium if premium > 1.00 & commercial == 1
sum premium if TwoStageAuction == 1

/*Exclude two-stage auctions from regression*/
xi: areg lnlandprice lnmaxfar if residential == 1 & TwoStageAuction == 0, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar if commercial == 1 & TwoStageAuction == 0, a(district_year) cl(locationcode)

/*Exclude noncompetitive auctions from regression*/      //*** Footnote 17 ***
xi: areg lnlandprice lnmaxfar if residential == 1 & premium > 1.00, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar if commercial == 1 & premium > 1.00, a(district_year) cl(locationcode)

drop TwoStageAuction premium 
/***************************************************************************************************/


/*****************************************************
- Analysis for new version
- Allow for different coefficients in different cities
- added on 12/4/2014
*****************************************************/

//Single coefficient case, copied from above:       *** Table 2, panel A ***
xi: areg lnlandprice lnmaxfar if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar if commercial == 1, a(district_year) cl(locationcode)

/************** For RESIDENTIAL LAND, 12/4/2014 *****************************/
//Count no. of observations in each city
sort city
ge number = 0
replace number = residential if _n == 1
replace number = number[_n-1] + residential if city == city[_n-1]
gsort city -number
replace number=number[_n-1] if city == city[_n-1] //Now number = no. of obs. in the city

ge city_R = city
replace city_R = "OtherCities" if number < 100 //call them "OtherCities" if no. of obs. < 100
drop number

//xi: areg lnlandprice i.city_R*lnmaxfar if residential == 1, a(district_year) cl(locationcode)
//Only city-FAR interactions included, equivalent regression:
xi: areg lnlandprice i.city_R|lnmaxfar if residential == 1, a(district_year) cl(locationcode)

//Describe coefficients
predict Coefficients if residential == 1 //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_R Coefficients
sum Coefficients if city_R != city_R[_n-1]
sort Coefficients city_R
sum Coefficients if city_R != city_R[_n-1]       // *** Table 2, panel B ***

label var Coefficients "Residential_Land_Coefficients"
hist Coefficients, bin(15)						// *** Figure 2 (i) *** 	
graph save Res_Land_Coefficients, replace

//List city-specific coefficients
list city_R city_pinyin Coefficients if city_R != city_R[_n-1] & Coefficients != .
//Save city-specific coefficients in a separate data file 
ge Residential_City = 0
replace Residential_City = 1 if city_R != city_R[_n-1] & Coefficients != .

postfile abc str20 (city city_pinyin) R_CityCoeff using R_CityCoefficients.dta, replace
	local N = _N
	forvalues i = 1/`N' {
	local j = Residential_City[`i']
	while (`j' > 0) {
post abc (city[`i']) (city_pinyin[`i']) (Coefficients[`i'])
	local j = `j' - 1
	}
}
postclose abc

drop Residential_City

drop Coefficients


/************** For COMMERCIAL LAND, 12/4/2014 *****************************/
//Count no. of observations in each city
sort city
ge number = 0
replace number = commercial if _n == 1
replace number = number[_n-1] + commercial if city == city[_n-1]
gsort city -number
replace number=number[_n-1] if city == city[_n-1] //Now number = no. of obs. in the city

ge city_C = city
replace city_C = "OtherCities" if number < 100 //call them "OtherCities" if no. of obs. < 100
drop number

//xi: areg lnlandprice i.city_C*lnmaxfar if commercial == 1, a(district_year) cl(locationcode)
//Only city-FAR interactions included, equivalent regression:
xi: areg lnlandprice i.city_C|lnmaxfar if commercial == 1, a(district_year) cl(locationcode)

//Describe coefficients
predict Coefficients if commercial == 1 //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_C Coefficients
sum Coefficients if city_C != city_C[_n-1]
sort Coefficients city_C
sum Coefficients if city_C != city_C[_n-1]       // *** Table 2, panel B ***

label var Coefficients "Commercial_Land_Coefficients"
hist Coefficients, bin(15)    					// *** Figure 2 (ii) *** 	
graph save Comm_Land_Coefficients, replace

//List city-specific coefficients
list city_C city_pinyin Coefficients if city_C != city_C[_n-1] & Coefficients != .
//Save city-specific coefficients in a separate data file 
ge Commercial_City = 0
replace Commercial_City = 1 if city_C != city_C[_n-1] & Coefficients != .

postfile abc str20 (city city_pinyin) C_CityCoeff using C_CityCoefficients.dta, replace
	local N = _N
	forvalues i = 1/`N' {
	local j = Commercial_City[`i']
	while (`j' > 0) {
post abc (city[`i']) (city_pinyin[`i']) (Coefficients[`i'])
	local j = `j' - 1
	}
}
postclose abc

drop Commercial_City

drop Coefficients
 

/* For REStat R&R, code added on 2/19/2016, interact FAR with Bartik and quality of life indexes */
sort city year
merge m:1 city year using YearlyCharacteristicsForRESTatRR.dta
drop if _merge == 2 //If city not in master file
drop _merge 

//Single coefficient, repeat the regressions above
xi: areg lnlandprice lnmaxfar if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar if commercial == 1, a(district_year) cl(locationcode) 

//Single coefficient changing with Bartik and quality of life indexes   *** Appendix Table A-2 ***
ge lnmaxfar_bartik1 = lnmaxfar*bartikindex2
xi: areg lnlandprice lnmaxfar lnmaxfar_bartik1 if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_bartik1 if commercial == 1, a(district_year) cl(locationcode)
ge lnmaxfar_bartik2 = lnmaxfar*bartikindex4
xi: areg lnlandprice lnmaxfar lnmaxfar_bartik2 if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_bartik2 if commercial == 1, a(district_year) cl(locationcode)

ge lnmaxfar_QoL1 = lnmaxfar*OverallScore
xi: areg lnlandprice lnmaxfar lnmaxfar_QoL1 if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_QoL1 if commercial == 1, a(district_year) cl(locationcode)
ge lnmaxfar_QoL2 = lnmaxfar*OverallRank
xi: areg lnlandprice lnmaxfar lnmaxfar_QoL2 if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_QoL2 if commercial == 1, a(district_year) cl(locationcode)

ge lnmaxfar_2ndSectorShare = lnmaxfar*SecondSectorShareGDP
xi: areg lnlandprice lnmaxfar lnmaxfar_2ndSectorShare if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_2ndSectorShare if commercial == 1, a(district_year) cl(locationcode)
ge lnmaxfar_3rdSectorShare = lnmaxfar*ThirdSectorShareGDP
xi: areg lnlandprice lnmaxfar lnmaxfar_3rdSectorShare if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_3rdSectorShare if commercial == 1, a(district_year) cl(locationcode)

ge lnmaxfar_JanTemp = lnmaxfar*Jan_Temperature_30YearAvg
xi: areg lnlandprice lnmaxfar lnmaxfar_JanTemp if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_JanTemp if commercial == 1, a(district_year) cl(locationcode)
ge lnmaxfar_JulyTemp = lnmaxfar*July_Temperature_30YearAvg
xi: areg lnlandprice lnmaxfar lnmaxfar_JulyTemp if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_JulyTemp if commercial == 1, a(district_year) cl(locationcode)
ge lnmaxfar_AnnualPrecip = lnmaxfar*(Annual_Precipitation_30YearAvg/100)
xi: areg lnlandprice lnmaxfar lnmaxfar_AnnualPrecip if residential == 1, a(district_year) cl(locationcode)
xi: areg lnlandprice lnmaxfar lnmaxfar_AnnualPrecip if commercial == 1, a(district_year) cl(locationcode)


//Check what's in the quality-of-life index
regr OverallScore januarytemp julytemp annualprecipitation if city != city[_n-1]
regr OverallScore OverallRank if city != city[_n-1]
/* For REStat R&R, code added on 2/19/2016, end here */
 


 /*part 6: regress FAR on city attributes*/
// *** Some of these results appeared in an earlier version, which were dropped during REStat R&R ***

gen lncitysize=log(population)
gen lncitysize2=(lncitysize)^2
gen lnrevenue=log(fiscalrevenue*10/population)
gen lnbeds=log(hospitalbeds*10/population)
gen lnbooks=log(library*10/population)
gen lnbus=log(bus*10/population)
gen lnroad=log(roadpercapita)
gen lngreen=log(greenland*10/population)


xi: areg lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnroad lngreen, a(city) cl(city)

xi: areg lnmaxfar i.year residential commercial lncitysize lnrevenue lnbeds lnbooks lnroad lngreen, /// 
a(cityid) cl(cityid) 

xi: areg lnmaxfar i.year residential commercial lncitysize lnrevenue lnbeds lnbooks lnroad lngreen, /// 
a(locationcode) cl(locationcode) 

xi: areg lnmaxfar i.year residential commercial lncitysize lncitysize2 lnrevenue lnbeds lnbooks lnroad lngreen, /// 
a(locationcode) cl(locationcode) 

xi: areg lnmaxfar i.year lncitysize lncitysize2 lnrevenue lnbeds lnbooks lnroad lngreen if residential == 1, /// 
a(locationcode) cl(locationcode) 
xi: areg lnmaxfar i.year lncitysize lncitysize2 lnrevenue lnbeds lnbooks lnroad lngreen if commercial == 1, /// 
a(locationcode) cl(locationcode)

xi: areg lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnroad lngreen if residential == 1, /// 
a(locationcode) cl(locationcode) 
xi: areg lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnroad lngreen if commercial == 1, /// 
a(locationcode) cl(locationcode) 

xi: regr lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnbus lnroad lngreen if residential == 1, /// 
cl(locationcode) 
xi: regr lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnbus lnroad lngreen if commercial == 1, /// 
cl(locationcode)


//Draft 2 Table:
xi: regr lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnbus lnroad lngreen if residential == 1, /// 
cl(cityid) 
xi: regr lnmaxfar i.year lncitysize lnrevenue lnbeds lnbooks lnbus lnroad lngreen if commercial == 1, /// 
cl(cityid)

//New draft table: FAR and city characteristics
xi: regr lnmaxfar i.year lncitysize lnrevenue lnbus lnroad if residential == 1, /// 
cl(cityid) 
display "adjusted R2 = " e(r2_a)
xi: regr lnmaxfar i.year lncitysize lnrevenue lnbus lnroad if commercial == 1, /// 
cl(cityid)
display "adjusted R2 = " e(r2_a)

xi: regr lnmaxfar i.year lncitysize lnrevenue lnbus lnroad if residential == 1 & /// 
city != "北京市" & city != "上海市" & city != "天津市" & city != "重庆市", cl(cityid) 

xi: regr lnmaxfar i.year lncitysize lnrevenue lnbus lnroad if residential == 1 & /// 
city != "北京市" & city != "上海市" & city != "天津市", cl(cityid) 

xi: regr lnmaxfar i.year lncitysize lnrevenue lnbus lnroad if residential == 1 & /// 
city != "北京市" & city != "上海市", cl(cityid) 

xi: regr lnmaxfar i.year lncitysize lnrevenue lnbus lnroad if residential == 1 & /// 
city != "上海市", cl(cityid) 




/* Average FARs 1/24/2014*/
sort city year
tab size

// *** Table 1, upper panel ***
//large: population2005 >= 2 million
sum maxfloorlotratio if size == "large" & residential == 1
sum maxfloorlotratio if size == "large" & commercial == 1
//medium: 2 million > population2005 > 1 million 
sum maxfloorlotratio if size == "medium" & residential == 1
sum maxfloorlotratio if size == "medium" & commercial == 1
//small: population2005 <= 1 million
sum maxfloorlotratio if size == "small" & residential == 1
sum maxfloorlotratio if size == "small" & commercial == 1

tab year

// *** Table 1, lower panel ***
sum maxfloorlotratio if year <= 2003 & residential == 1
sum maxfloorlotratio if year <= 2003 & commercial == 1

sum maxfloorlotratio if year >= 2004 & year <= 2005 & residential == 1
sum maxfloorlotratio if year >= 2004 & year <= 2005 & commercial == 1

sum maxfloorlotratio if year >= 2006 & year <= 2007 & residential == 1
sum maxfloorlotratio if year >= 2006 & year <= 2007 & commercial == 1

sum maxfloorlotratio if year >= 2008 & year <= 2009 & residential == 1
sum maxfloorlotratio if year >= 2008 & year <= 2009 & commercial == 1

sum maxfloorlotratio if year >= 2010 & residential == 1
sum maxfloorlotratio if year >= 2010 & commercial == 1

/* Collapse data at city level 1/24/2014*/
sort city year

replace maxfloorlotratio = . if residential != 1 // Residential land only
//replace maxfloorlotratio = . if commercial != 1 // Commercial land only

keep city city_pinyin year maxfloorlotratio population lncitysize lnrevenue lnbeds lnbooks lnbus lnroad lngreen

ge population2005 = .
replace population2005 = population if year == 2005
ge lncitysize2005 = .
replace lncitysize2005 = lncitysize if year == 2005
ge lnrevenue2005 = .
replace lnrevenue2005 = lnrevenue if year == 2005
ge lnbeds2005 = .
replace lnbeds2005 = lnbeds if year == 2005
ge lnbooks2005 = .
replace lnbooks2005 = lnbooks if year == 2005
ge lnbus2005 = .
replace lnbus2005 = lnbus if year == 2005
ge lnroad2005 = .
replace lnroad2005 = lnroad if year == 2005
ge lngreen2005 = .
replace lngreen2005 = lngreen if year == 2005
ge year2005 = .
replace year2005 = year if year == 2005

ge population2010 = .
replace population2010 = population if year == 2010
ge lncitysize2010 = .
replace lncitysize2010 = lncitysize if year == 2010
ge lnrevenue2010 = .
replace lnrevenue2010 = lnrevenue if year == 2010
ge lnbeds2010 = .
replace lnbeds2010 = lnbeds if year == 2010
ge lnbooks2010 = .
replace lnbooks2010 = lnbooks if year == 2010
ge lnbus2010 = .
replace lnbus2010 = lnbus if year == 2010
ge lnroad2010 = .
replace lnroad2010 = lnroad if year == 2010
ge lngreen2010 = .
replace lngreen2010 = lngreen if year == 2010
ge year2010 = .
replace year2010 = year if year == 2010

drop year population lncitysize lnrevenue lnbeds lnbooks lnbus lnroad lngreen

collapse (mean) maxfloorlotratio year2005 population2005 lncitysize2005 lnrevenue2005 ///
lnbeds2005 lnbooks2005 lnbus2005 lnroad2005 lngreen2005 ///
year2010 population2010 lncitysize2010 lnrevenue2010 lnbeds2010 ///
lnbooks2010 lnbus2010 lnroad2010 lngreen2010, by(city) 

tab year2005
tab year2010

ge lnMeanFAR = log(maxfloorlotratio)
regr lnMeanFAR lncitysize2005 lnrevenue2005 lnbeds2005 lnbooks2005 lnbus2005 lnroad2005 lngreen2005
regr lnMeanFAR lncitysize2010 lnrevenue2010 lnbeds2010 lnbooks2010 lnbus2010 lnroad2010 lngreen2010

keep city maxfloorlotratio population2010
save ResidentialMeanFAR.dta, replace  //*** Used to draw the map in Figure 1. ***

clear



/****************************************************************************
For REStat R&R: Regress city specific coefficients on 2005 city characteristics,
exected in a separate do file (StringencyRegression.do)
*****************************************************************************/


do StringencyRegression.do   // *** Table 3 ***

clear


log close


