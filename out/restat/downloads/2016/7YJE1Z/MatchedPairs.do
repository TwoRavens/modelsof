/***********************************************************
do file name: MatchedPairs.do,

Identify clusters and run the log-log regression controlling 
for cluster fixed effects

Originally created by: Junfu Zhang on 12/8/2014

************************************************************/

clear matrix


log using MatchedPairs, t replace

set rmsg on
set more off
set matsize 800
set memory 1g
set varlabelpos 15

            
//For Residential land
use ResidentialLandSales.dta

xi: areg lnlandprice lnmaxfar, a(pair) cl(city) //With outliers

/*drop outliers in top and bottom 1% of landprice or maxfloorlotratio*/
drop if landprice<90.71 | landprice>26457.67 | maxfloorlotratio<0.3 | maxfloorlotratio>7.5

/*After droppng outliers, some pairs are not pairs anymore*/
sort pair 
replace pair = . if pair != . & pair != pair[_n-1] & pair != pair[_n+1]

sort city landusage
count if city == "北京市"
count if city == "北京市" & landusage != landusage[_n-1] //How different landuseage is.
tab district if city == "北京市" //Count the number of district in Beijing

//Address missing data are labeled with "-"; identify them
count if address12 == "-"
count if address12 == "-" & pair != .
replace pair = . if address12 == "-" & pair != .

//Check the number of observations in each cluster
drop if pair == .
sort pair
ge pair_obs_no = 1
replace pair_obs_no = pair_obs_no[_n-1]+1 if pair == pair[_n-1]
tab pair_obs_no if pair != pair[_n+1]
gsort pair -pair_obs_no
replace pair_obs_no = pair_obs_no[_n-1] if pair == pair[_n-1]
tab pair_obs_no if pair != pair[_n-1]


xi: areg lnlandprice lnmaxfar, a(pair) cl(city) //Same coefficient, outliers excluded  *** Table 2, panel C ***

//What if only control for city-district by year fixed effects, as in the regression using the whole sample?
sort city district year
gen city_dist_year = _n
replace city_dist_year = city_dist_year[_n-1] if city == city[_n-1] & ///
district == district[_n-1] & year == year[_n-1]
xi: areg lnlandprice lnmaxfar, a(city_dist_year) cl(city) //Control for city-district by year fixed effects
drop city_dist_year

/************************************************************************************************* 4/28/2016**/
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
xi: areg lnlandprice lnmaxfar if TwoStageAuction == 0, a(pair) cl(city)

/*Exclude noncompetitive auctions from regression*/
xi: areg lnlandprice lnmaxfar if premium > 1.00, a(pair) cl(city)        // *** Footnote 17 ***

drop TwoStageAuction premium 
/************************************************************************************************* 4/28/2016**/



//Estimate city-specific coefficients

sort city pair
ge number = 1
replace number = number[_n-1] + 1 if city == city[_n-1]

gsort city -number
replace number = number[_n-1] if city == city[_n-1] //Now it is number of obs. in the city
tab city if number > 30

ge city_R = city_pinyin
replace city_R = "AAA_Other" if number < 30 
xi: areg lnlandprice i.city_R|lnmaxfar, a(pair) //For cities with >=30 obs.

	//Describe coefficients
predict Coefficients //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_R Coefficients
sum Coefficients if city_R != city_R[_n-1]
sort Coefficients city_R
sum Coefficients if city_R != city_R[_n-1]
list city city_R Coefficients if city_R != city_R[_n-1] & Coefficients != .

label var Coefficients "Residential_Land_Coefficients"
hist Coefficients, bin(10)
//graph save Coefficients_PairApproach30, replace

drop Coefficients


replace city_R = "AAA_Other" if number < 40
xi: areg lnlandprice i.city_R|lnmaxfar, a(pair) //For cities with >=40 obs.

	//Describe coefficients
predict Coefficients //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_R Coefficients
sum Coefficients if city_R != city_R[_n-1]
sort Coefficients city_R
sum Coefficients if city_R != city_R[_n-1]
list city city_R Coefficients if city_R != city_R[_n-1] & Coefficients != .

label var Coefficients "Residential_Land_Coefficients"
hist Coefficients, bin(10)
graph save Coefficients_PairApproach40, replace

drop Coefficients


replace city_R = "AAA_Other" if number < 50
xi: areg lnlandprice i.city_R|lnmaxfar, a(pair) //For cities with >=50 obs.   *** Table 2, panel D ***

	//Describe coefficients
predict Coefficients //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_R Coefficients
sum Coefficients if city_R != city_R[_n-1]
sort Coefficients city_R
sum Coefficients if city_R != city_R[_n-1]
list city city_R Coefficients if city_R != city_R[_n-1] & Coefficients != .

label var Coefficients "Residential_Land_Coefficients"
hist Coefficients, bin(10)                             // *** Figure 2, (iii) ***
graph save Coefficients_PairApproach50, replace

drop Coefficients

drop number

clear



//For Commercial land
use CommercialLandSales.dta

xi: areg lnlandprice lnmaxfar, a(pair) cl(city) //With outliers

/*drop outliers in top and bottom 1% of landprice or maxfloorlotratio*/
drop if landprice<90.71 | landprice>26457.67 | maxfloorlotratio<0.3 | maxfloorlotratio>7.5

/*After droppng outliers, some pairs are not pairs anymore*/ 
sort pair 
replace pair = . if pair != . & pair != pair[_n-1] & pair != pair[_n+1]

//Address missing data are labeled with "-"; identify them
count if address12 == "-"
count if address12 == "-" & pair != .
replace pair = . if address12 == "-" & pair != .

//Check the number of observations in each cluster
drop if pair == .
sort pair
ge pair_obs_no = 1
replace pair_obs_no = pair_obs_no[_n-1]+1 if pair == pair[_n-1]
tab pair_obs_no if pair != pair[_n+1]
gsort pair -pair_obs_no
replace pair_obs_no = pair_obs_no[_n-1] if pair == pair[_n-1]
tab pair_obs_no if pair != pair[_n-1]


xi: areg lnlandprice lnmaxfar, a(pair) cl(city) //Same coefficient, outliers excluded  *** Table 2, panel C

//What if only control for city-district by year fixed effects, as in the regression using the whole sample?
sort city district year
gen city_dist_year = _n
replace city_dist_year = city_dist_year[_n-1] if city == city[_n-1] & ///
district == district[_n-1] & year == year[_n-1]
xi: areg lnlandprice lnmaxfar, a(city_dist_year) cl(city) //Control for city-district by year fixed effects
drop city_dist_year


/************************************************************************************************* 4/28/2016**/
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
xi: areg lnlandprice lnmaxfar if TwoStageAuction == 0, a(pair) cl(city)          // *** Footnote 17 ***

/*Exclude noncompetitive auctions from regression*/
xi: areg lnlandprice lnmaxfar if premium > 1.00, a(pair) cl(city)

drop TwoStageAuction premium 
/************************************************************************************************* 4/28/2016**/



//Estimate city-specific coefficients

sort city pair
ge number = 1
replace number = number[_n-1] + 1 if city == city[_n-1]

gsort city -number
replace number = number[_n-1] if city == city[_n-1] //Now it is number of obs. in the city
tab city if number > 30

ge city_C = city_pinyin
replace city_C = "AAA_Other" if number < 30 
xi: areg lnlandprice i.city_C|lnmaxfar, a(pair) //For cities with >=30 obs.

	//Describe coefficients
predict Coefficients //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_C Coefficients
sum Coefficients if city_C != city_C[_n-1]
sort Coefficients city_C
sum Coefficients if city_C != city_C[_n-1]
list city city_C Coefficients if city_C != city_C[_n-1] & Coefficients != .

label var Coefficients "Commercial_Land_Coefficients"
hist Coefficients, bin(10)
//graph save Coefficients_PairApproach30_C, replace

drop Coefficients


replace city_C = "AAA_Other" if number < 40
xi: areg lnlandprice i.city_C|lnmaxfar, a(pair) //For cities with >=40 obs.

	//Describe coefficients
predict Coefficients //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_C Coefficients
sum Coefficients if city_C != city_C[_n-1]
sort Coefficients city_C
sum Coefficients if city_C != city_C[_n-1]
list city city_C Coefficients if city_C != city_C[_n-1] & Coefficients != .

label var Coefficients "Commercial_Land_Coefficients"
hist Coefficients, bin(10)
graph save Coefficients_PairApproach40_C, replace

drop Coefficients


replace city_C = "AAA_Other" if number < 50
xi: areg lnlandprice i.city_C|lnmaxfar, a(pair) //For cities with >=50 obs.

	//Describe coefficients
predict Coefficients //Predict value
replace Coefficients = (Coefficients - _b[_cons])/lnmaxfar //Calculate coefficients for different cities
sort city_C Coefficients
sum Coefficients if city_C != city_C[_n-1]
sort Coefficients city_C
sum Coefficients if city_C != city_C[_n-1]                  // *** Table 2, panel D ***
list city city_C Coefficients if city_C != city_C[_n-1] & Coefficients != .

label var Coefficients "Commercial_Land_Coefficients"
hist Coefficients, bin(10)                             // Figure 2, (iv)
graph save Coefficients_PairApproach50_C, replace

drop Coefficients

drop number

clear
log close
