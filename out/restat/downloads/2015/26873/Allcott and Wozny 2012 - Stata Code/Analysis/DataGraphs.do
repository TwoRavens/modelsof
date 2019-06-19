/* DataGraphs.do */
/* This file creates graphs and some tables. */
/* Allcott and Wozny (2012) */

set more off

/* DESCRIPTIVE STATISTICS */
use AutoPQXG.dta, clear
rename G1000000006025024100110 GasCost
gen MPG = 1/GPM

label var ModelYear "Model Year"
label var GasCost "PDV of Gas Cost (\$)"
label var Price "Price (\$)"
label var MPG "Fuel Economy (MPG)"
label var Quantity "Quantity"
label var HP "Horsepower"
label var Weight "Weight (pounds)"
label var Wheelbase "Wheelbase (inches)"
label var NumObs "Number of Transactions"

sum Year ModelYear Age Price Quantity GasCost MPG HP Weight Wheelbase NumObs if Age>=1&Age<=15&Price!=.&GasCost!=.
sutex Year ModelYear Age Price Quantity GasCost MPG HP Weight Wheelbase NumObs, digits(1) labels minmax replace file(Output/SumStats), if Age>=1&Age<=15&Price!=.&GasCost!=.

/* PRICE VS. MPG GRAPH */
use Data/Attributes/Wards/WardsAttributes.dta,clear
replace MSRP = MSRP/1000
replace Weight = Weight/1000

gen MPG = round((.57/MPGCity+.43/MPGHwy)^(-1))

xi i.MPG, pre(_M) noomit
reg MSRP MPG
local mpgcons = _b[_cons]
local mpgcoeff = _b[MPG]

reg MSRP _M*, robust nocons
forvalues mpg = 11/50 {
capture local pricecoeff_`mpg' = _b[_MMPG_`mpg']
capture local pricese_`mpg' = _se[_MMPG_`mpg']
}

reg Weight _M*, robust nocons
forvalues mpg = 11/50 {
capture local weightcoeff_`mpg' = _b[_MMPG_`mpg']
capture local weightse_`mpg' = _se[_MMPG_`mpg']
}

clear
set obs 0
gen MPG = .
gen Price = .
gen Price90 = .
gen Price10 = .
gen Weight = .
gen Weight90 = .
gen Weight10 = .
gen PredPrice =.
forvalues mpg=11/50 {
	sum
	local N_1 = _N+1
	set obs `N_1'
	capture replace MPG = `mpg' if MPG==.
	capture replace Price = `pricecoeff_`mpg'' if MPG==`mpg'
	capture replace Price90 = `pricecoeff_`mpg'' + 1.645*`pricese_`mpg'' if MPG==`mpg'
	capture replace Price10 = `pricecoeff_`mpg'' - 1.645*`pricese_`mpg'' if MPG==`mpg'
	capture replace Weight = `weightcoeff_`mpg'' if MPG==`mpg'
	capture replace Weight90 = `weightcoeff_`mpg'' + 1.645*`weightse_`mpg'' if MPG==`mpg'
	capture replace Weight10 = `weightcoeff_`mpg'' - 1.645*`weightse_`mpg'' if MPG==`mpg'
	capture replace PredPrice = MPG*`mpgcoeff'+`mpgcons'
}

outsheet using Output/MPGvsPrice.csv, comma names replace



/* GAS PRICE EXPECTATIONS */
/* Gas Price Expectations Graph */
use Data/GasPrices/GasPriceExpectations.dta, clear

keep if Year>=1991
keep Year Month GasPrice Eg2 Eg5 Eg8
sort Year Month
outsheet using Output/GasPriceExpectations.csv, comma nonames replace

/* Gas Price Expectations Table */
use Data/GasPrices/GasPriceExpectations.dta, clear

keep if Year>=1998&Year<=2008
collapse (mean) GasPrice Eg?, by(Year)
sort Year
outsheet using Output/GasPriceExpectationsTable.csv, comma nonames replace


********************************************************************
********************************************************************


/* GAS COST IDENTIFICATION GRAPH */
use AutoPQXG_Small.dta, clear
keep if Year==2004&Month==6
replace MPG = round(MPG)
keep Age MPG OrigGasCost
collapse (mean) OrigGasCost, by(Age MPG)
reshape wide OrigGasCost, i(MPG) j(Age)

* Linearly interpolate missing data
drop if MPG<10|MPG>32
forvalues a = 1/20 {
replace OrigGasCost`a' = OrigGasCost`a'[_n+1]*MPG[_n+1]/MPG     if MPG<20&OrigGasCost`a'==.
replace OrigGasCost`a' = OrigGasCost`a'[_n+1]*MPG[_n+1]/MPG     if MPG<20&OrigGasCost`a'==.

replace OrigGasCost`a' = OrigGasCost`a'[_n-1]*MPG[_n-1]/MPG     if MPG>=20&OrigGasCost`a'==.
}

outsheet using Output/GIdVariationGraph.csv, comma names replace


*********************************************************************************
*********************************************************************************

/* GENERATE THE DEMEANED DATASET FOR 1999-2008 */
use AutoPQXG.dta,clear

** Drop exotics
sort Make Model
merge m:1 Make Model using ExoticList.dta, assert(match)
drop if Exotic
		

* Drop vans
keep if VClass<=9
keep if Age>=1&Age<=15


rename G1000000006025024100110 GasCost
rename G1000000006025024100000 GasCostMart


       
     /* Use BLP rule to divide a CarID into generations based on characteristics.  An alternate CarID is created. */
     /* Presumably characteristics of the same CarID and ModelYear should not change over time.  In case they do,
        perform this test only for the month of January and the youngest age observed in the dataset.  */
     gen OrigCarID = CarID
	 sort Month CarID Age ModelYear
     /* Liters and GPM seem like the best characteristics to use that are avaialble outside of the Wards data. */
         by Month CarID Age: gen BigChange =(abs(Liters-Liters[_n-1])/Liters[_n-1]>=.1) & Liters!=. & Liters[_n-1]!=. if _n>1
     qui by Month CarID Age: replace BigChange = 1 if abs(GPM-GPM[_n-1])/GPM[_n-1]>=.1 & GPM!=. & GPM[_n-1]!=. & _n>1
     gen GenNum = 1
     qui by Month CarID Age: replace GenNum = GenNum[_n-1] + BigChange if _n>1
     sort CarID ModelYear Age Month
     qui by CarID ModelYear: replace GenNum = GenNum[1]
     by CarID: egen NumGens = max(GenNum)
     by CarID: gen firstrec=(_n==1)
     tab NumGens if firstrec
     drop NumGens firstrec
     egen CarGenID = group(CarID GenNum)
     qui replace CarID = CarGenID

	
	** Establish fixed effect groups
	egen FEGroup = group(CarID Age)



	sort FEGroup Year Month
    gen HavePrice = (Price < .)
    gen HavePosQ = (Quantity < . & Quantity>0)
	gen HaveG = (GasCost < .)
    gen HaveInst = (G0<.)
    gen ObsValidNL = (HavePrice & HavePosQ & HaveG & HaveClass & HaveInst & NumObs>0)
	gen ObsValidRF = (HavePrice & HaveG & NumObs>0)
	by FEGroup: egen NumValidObsRF = total(ObsValidRF)
	by FEGroup: egen NumValidObsNL = total(ObsValidNL)
	
    *keep if NumValidObsRF>=2 & ObsValidRF
	keep if NumValidObsNL>=2 & ObsValidNL
    drop NumValidObsRF NumValidObsNL
	
	** Make MPG bins
	gen MPG=1/GPM
	xtile MPGBin = MPG, nquantiles(2)
		
	/* De-mean */
		sort FEGroup
		by FEGroup: egen TotalObs = total(NumObs)
		gen OrigPrice = Price
		gen OrigGasCost = GasCost
		gen OrigGasCostMart = GasCostMart
		
		foreach var of varlist Price GasCost GasCostMart {
				by FEGroup: egen WeightedSum`var' = total(NumObs*`var')
				gen DM`var' = `var' - WeightedSum`var'/TotalObs
				qui replace `var' = DM`var'
				drop WeightedSum`var' DM`var'
		}
	
	** Take out monthly trend
	xi i.Month*i.MPGBin, pre(_M)
	
	reg Price _M* [fweight = NumObs]
	predict PriceHat
	gen PriceResid = Price-PriceHat
	
	reg GasCost _M* [fweight = NumObs]
	predict GasCostHat
	gen GasCostResid = GasCost-GasCostHat
	
	reg GasCostMart _M* [fweight = NumObs]
	predict GasCostMartHat
	gen GasCostMartResid = GasCostMart-GasCostMartHat
	
	drop Price GasCost GasCostMart
	rename OrigPrice Price
	rename OrigGasCost GasCost
	rename OrigGasCostMart GasCostMart

keep Year Month NumObs Price PriceResid GasCost GasCostResid GasCostMart GasCostMartResid MPGBin
save AutoPQXGDemeaned08.dta, replace

*******************************************************
*******************************************************



/* AVERAGE PRICES GRAPH */
	* This will be average prices only for vehicles in the primary specification, i.e. with more than two observations per ja.
/* Get price level */

	
collapse (mean) Price PriceResid [fweight = NumObs], by(Year Month)

sort Year Month
merge Year Month using Data/GasPrices/GasPriceExpectations.dta, nokeep

egen CompositeFutures = rowmean(Eg0 Eg1 Eg2 Eg3 Eg4 Eg5 Eg6 Eg7 Eg8 Eg9)


** Test correlation
reg Price CompositeFutures if (Year<=2007|Month<=3), robust
reg Price CompositeFutures if (Year<=2007|Month<=3)&Year>=2001, robust
reg Price Eg2 if (Year<=2007|Month<=3), robust
reg Price Eg2 if (Year<=2007|Month<=3)&Year>=2003, robust


foreach var in Price PriceResid {
replace `var' = `var'/1000
}
keep Year  Month  Price PriceResid CompositeFutures
order Year  Month  Price PriceResid CompositeFutures
outsheet using Output/MeanPrice.csv, comma names replace


***************************************************************
***************************************************************

/* RAW PRICE VS. RAW MPG GRAPH */
use AutoPQXGDemeaned08.dta, replace
gen SumNumObs = 1
collapse (sum) SumNumObs (mean) Price GasCost [fweight = NumObs], by(Year Month MPGBin)
reshape wide Price GasCost SumNumObs, i(Year Month) j(MPGBin)

foreach var in Price GasCost {
gen `var' = `var'1 - `var'2
}

gen SumNumObs = (SumNumObs1+SumNumObs2)/2

reg Price GasCost [aw=SumNumObs] if Year<2004
predict OrigPricePre2004

reg Price GasCost [aw=SumNumObs] if Year>=2004|(Year==2008&Month<=3)
predict OrigPrice0408

reg Price GasCost [aw=SumNumObs] if (Year==2008&Month>3)
predict OrigPrice08

keep Year Month Price GasCost OrigPricePre2004 OrigPrice0408 OrigPrice08 SumNumObs
order Year Month Price GasCost OrigPricePre2004 OrigPrice0408 OrigPrice08 SumNumObs

outsheet using Output/RawPGScatter.csv, comma names replace

*************************************************************
*************************************************************

/* GROUP PRICE GRAPHS: RESIDUALS OVER TIME */
use AutoPQXGDemeaned08.dta,clear
gen SumNumObs = 1
collapse (sum) SumNumObs (mean) PriceResid GasCostResid GasCostMartResid [fweight = NumObs], by(Year Month MPGBin)
reg PriceResid GasCostResid [aw=SumNumObs], robust
reg PriceResid GasCostMartResid [aw=SumNumObs], robust
drop SumNumObs

reshape wide PriceResid GasCostResid GasCostMartResid, i(Year Month) j(MPGBin)
foreach var in PriceResid GasCostResid GasCostMartResid {
	gen `var' = `var'1-`var'2
}

order Year Month PriceResid GasCostResid GasCostMartResid

outsheet using Output/GroupPriceGraph.csv, comma names replace


*****************************************************************
*****************************************************************


/* TRENDS IN MPG OF NEW VEHICLE SALES (INSTRUMENT IDENTIFICATION GRAPH */

use AutoPQXG.dta, clear
** Drop exotics
drop if Exotic==1
* Drop vans
keep if VClass<=9
* Keep only Year = ModelYear+1 to get new vehicle sales
keep if Age==1|(Age>=2&Age<=6&Year==1999)

bysort CarID ModelYear Year: gen AnnualQuantity = Quantity * (_n==1)
gen MPG = 1/UnadjGPM
gen MPGBin = 1 if MPG<20
replace MPGBin = 2 if MPG>=20

collapse (sum) AnnualQuantity, by(MPGBin ModelYear)
replace AnnualQuantity = AnnualQuantity/1000000
reshape wide AnnualQuantity, i(ModelYear) j(MPGBin)
sort ModelYear
merge ModelYear using Data/GasPrices/GasPriceExpectationsInstrument.dta, nokeep
egen CompositeFutures = rowmean(Eg2)
keep ModelYear AnnualQuantity? CompositeFutures
order ModelYear AnnualQuantity? CompositeFutures

outsheet using Output/MPGSalesTrends.csv, comma names replace


**
