/* GetGasPrice.do */
/* Notes:
We only have inflation expectations to 2003. We address this by assuming that inflation expectations
were 2.0 percent per year. This is roughly consistent with observed inflation over 1998-2002. */

# delimit cr

*********************
/* SETUP */
*quietly {
*set more off
*clear
*set mem 400m
*set matsize 800


/* PREPARE AND IMPORT DATA */
/* LSCO SPOT PRICES (NYMEX) */
insheet using Data/OilFutures/LSCOSpotPricesfromEIA.csv, comma names clear
rename month Month
rename year Year
drop date
rename lscospotprice NomLSCOSpot
sort Year Month
merge Year Month using Data/CPI/MonthlyCPI.dta, keep(CPIDeflator) nokeep
gen LSCOSpot = NomLSCOSpot*CPIDeflator
drop _merge CPIDeflator NomLSCOSpot
drop if LSCOSpot==.
sort Year Month
saveold Data/OilFutures/LSCOSpotPrices.dta, replace

/* INFLATION EXPECTATIONS */
* http://www.federalreserve.gov/releases/h15/data.htm#fn14
clear
set obs 1
gen Year = .
gen Month = .
sort Year Month
saveold Data/OilFutures/Treasuries/TreasuriesData.dta,replace
foreach type in II NOM {
foreach mat in 5 7 10 20 {

insheet using Data/OilFutures/Treasuries/H15_TCM`type'_Y`mat'.txt, comma clear
rename v1 date
rename v2 yield`type'`mat'
drop v3
destring yield`type'`mat', replace force
drop if yield`type'`mat'==.

gen Month = real(substr(date,1,2))
gen Year = real(substr(date,4,4))
drop date
sort Year Month

merge Year Month using Data/OilFutures/Treasuries/TreasuriesData.dta
drop _merge
sort Year Month
saveold Data/OilFutures/Treasuries/TreasuriesData.dta, replace

}
}

drop if yieldII5==.
order Year Month yield*
saveold Data/OilFutures/Treasuries/TreasuriesData.dta, replace

/* Get Inflation Expectations from Treasury Yields */
foreach mat in 5 7 10 20 {
gen EInf`mat' = yieldNOM`mat'-yieldII`mat'
}

saveold Data/OilFutures/Treasuries/TreasuriesData.dta, replace


/* PREPARE NYMEX FUTURES PRICES */
/* Import NYMEX Futures */

** Initialize Dataset
clear
set obs 0
gen Year = .
saveold Data/OilFutures/NYMEX/NYMEXData.dta,replace

local y = 83
forvalues m = 6/12 {
	include Data/OilFutures/NYMEX/ImportNYMEXtxt.do
}


forvalues y = 84/99 {
forvalues m = 1/12 {
	include Data/OilFutures/NYMEX/ImportNYMEXtxt.do
}
}

forvalues y = 0/9 {
forvalues m = 1/12 {
	include Data/OilFutures/NYMEX/ImportNYMEXtxt.do
}
}

forvalues y = 10/13 {
forvalues m = 1/12 {
	include Data/OilFutures/NYMEX/ImportNYMEXtxt.do
}
}

forvalues y = 14/16 {
forvalues m = 6(6)12 {   /* This only does 6 and 12 */
	include Data/OilFutures/NYMEX/ImportNYMEXtxt.do
}
}



/* Collapse NYMEX Data */
gen ft = cond(fMonth-Month>=0,(fYear-Year)*100 + fMonth-Month,(fYear-Year-1)*100+12+fMonth-Month)

order Year Month day fYear fMonth ft
sort Year Month day ft
saveold Data/OilFutures/NYMEX/NYMEXData.dta, replace
*} /* closes quietly loop */

drop fMonth fYear
collapse (mean) fprice_ny, by(Year Month ft)

/* Translate to 2005 Dollars */
** Merge Inflation Expectations
sort Year Month
merge Year Month using Data/OilFutures/Treasuries/TreasuriesData.dta, keep(E*) nokeep
drop _merge
* Use 2% expected inflation for years before 2003. This is roughly consistent with actual observed inflation over the period 1998-2002.
foreach var in EInf5 EInf7 EInf10 {
replace `var' = 2.0 if `var'==.
}


gen YrsInFuture = floor(ft / 100)
replace YrsInFuture = YrsInFuture + (ft-YrsInFuture*100)/12

** Fix 0-6 year term with 5 year inflation expectation
replace fprice_ny = fprice_ny/(1+EInf5/100)^YrsInFuture if YrsInFuture <=6

** Fix 6-8.5 year term with 7 year inflation expectation
replace fprice_ny = fprice_ny/(1+EInf7/100)^YrsInFuture if YrsInFuture > 6 & YrsInFuture<=8.5

** Fix >8.5 year term with 10 year inflation expectation
replace fprice_ny = fprice_ny/(1+EInf10/100)^YrsInFuture if YrsInFuture > 8.5

drop E* YrsInFuture

** Merge CPI
sort Year Month
merge Year Month using Data/CPI/MonthlyCPI.dta, keep(CPIDeflator) nokeep
drop _merge

** Deflate to 2005 Dollars
replace fprice_ny = fprice_ny * CPIDeflator
drop CPIDeflator

** Reshape and Save
reshape wide fprice_ny, i(Year Month) j(ft)
saveold Data/OilFutures/NYMEX/NYMEXData.dta, replace


/* ICE DATA */
** Import Data
insheet using "Data/OilFutures/ICE/EOD_Futures_ProductFile_ProductID(254).csv", comma clear
keep date stripname settlementprice
drop if settlementprice==.
drop if substr(stripname,1,1)=="Q" | substr(stripname,1,1)=="C" /* These are redundant strips for quarters or calendar Years. The Month contracts actually are reported further out */
rename settlementprice fprice_ice

* Get date
gen slash = strpos(date,"/")
gen Month = real(substr(date,1,slash-1))
replace date = substr(date,slash+1,length(date)-slash)
replace slash = strpos(date,"/")
gen day = real(substr(date,1,slash-1))
gen Year = substr(date,slash+1,length(date)-slash)
destring Year, replace force
replace Year = 2000+Year
drop slash date

* Get fYear
gen dash = strpos(stripname,"-")
gen fYear = substr(stripname,1,dash-1)
destring fYear, replace force
replace fYear = 2000+fYear

* Get fMonth
gen fMonth = substr(stripname,dash+1,length(stripname)-dash)
drop dash stripname
replace fMonth = "1" if fMonth =="Jan"
replace fMonth = "2" if fMonth =="Feb"
replace fMonth = "3" if fMonth =="Mar"
replace fMonth = "4" if fMonth =="Apr"
replace fMonth = "5" if fMonth =="May"
replace fMonth = "6" if fMonth =="Jun"
replace fMonth = "7" if fMonth =="Jul"
replace fMonth = "8" if fMonth =="Aug"
replace fMonth = "9" if fMonth =="Sep"
replace fMonth = "10" if fMonth =="Oct"
replace fMonth = "11" if fMonth =="Nov"
replace fMonth = "12" if fMonth =="Dec"

destring fMonth, replace force


* Get ft
gen ft = cond(fMonth-Month>=0,(fYear-Year)*100 + fMonth-Month,(fYear-Year-1)*100+12+fMonth-Month)

order Year Month day fYear fMonth
sort Year Month day ft
saveold Data/OilFutures/ICE/ICEData.dta, replace

drop fMonth fYear
* Need to drop one observation that is repeated and gives a reshape error
gen flag = cond(Year==2006&Month==9&day==1&ft==110,1,0)
drop if flag==1&flag[_n-1]==1
drop flag

collapse (mean) fprice_ice, by(Year Month ft)

/* Translate to 2005 Dollars */
** Merge Inflation Expectations
sort Year Month
merge Year Month using Data/OilFutures/Treasuries/TreasuriesData.dta, keep(E*) nokeep
drop _merge

* Use 2% expected inflation for years before 2003. This is roughly consistent with actual observed inflation over the period 1998-2002.
foreach var in EInf5 EInf7 EInf10 {
replace `var' = 2.0 if `var'==.
}

gen YrsInFuture = floor(ft / 100)
replace YrsInFuture = YrsInFuture + (ft-YrsInFuture*100)/12

** Fix 0-6 year term with 5 year inflation expectation
replace fprice_ice = fprice_ice/(1+EInf5/100)^YrsInFuture if YrsInFuture <=6

** Fix 6-8.5 year term with 7 year inflation expectation
replace fprice_ice = fprice_ice/(1+EInf7/100)^YrsInFuture if YrsInFuture > 6 & YrsInFuture<=8.5

** Fix >8.5 year term with 10 year inflation expectation
replace fprice_ice = fprice_ice/(1+EInf10/100)^YrsInFuture if YrsInFuture > 8.5

drop E* YrsInFuture

** Merge CPI
sort Year Month
merge Year Month using Data/CPI/MonthlyCPI.dta, keep(CPIDeflator) nokeep
drop _merge

** Deflate to 2005 Dollars
replace fprice_ice = fprice_ice * CPIDeflator
drop CPIDeflator

/* Reshape and Save */
reshape wide fprice_ice, i(Year Month) j(ft)
saveold Data/OilFutures/ICE/ICEData.dta, replace


*********************
/* GASOLINE PRICES */
* Note that GasPrice is seasonally adjusted in levels, while GasPriceUndjusted is not seasonally adjusted.
insheet using "Data/GasPrices/EIA Retail Gasoline Prices 1973-Present.csv", comma nonames clear
drop if _n<14
gen CalYear = real(substr(v1,1,4))

gen MonthName = substr(v1,6,length(v1)-5)
gen Month = cond(MonthName=="January",1,.)
replace Month = 2 if MonthName=="February"
replace Month = 3 if MonthName=="March"
replace Month = 4 if MonthName=="April"
replace Month = 5 if MonthName=="May"
replace Month = 6 if MonthName=="June"
replace Month = 7 if MonthName=="July"
replace Month = 8 if MonthName=="August"
replace Month = 9 if MonthName=="September"
replace Month = 10 if MonthName=="October"
replace Month = 11 if MonthName=="November"
replace Month = 12 if MonthName=="December"

gen Year = CalYear

rename v5 NomGasPrice
rename v2 Leaded
rename v3 Unleaded
destring NomGasPrice Leaded Unleaded, replace force

** Impute Nominal gas price if missing
reg NomGasPrice Leaded Unleaded if Year>=1978&Year<=1981
predict NomGasPriceHat
replace NomGasPrice = Leaded if NomGasPrice==.&NomGasPriceHat==.
replace NomGasPrice = NomGasPriceHat if NomGasPrice==.

replace NomGasPrice = NomGasPrice/100

** Inflate to 2005 dollars.
sort Year Month
merge Year Month using Data/CPI/MonthlyCPI.dta,nokeep
drop _merge
gen GasPrice = NomGasPrice*CPIDeflator
keep Year Month GasPrice
drop if Month==.|GasPrice==.
sort Year Month

** Seasonally adjust the Gas Spot Prices in levels
gen GasPriceUnadjusted = GasPrice
sum GasPrice
local AverageGasPrice=r(mean)
gen GasPrice0=GasPrice-`AverageGasPrice'
char Month [omit] 7
xi i.Month, pre(_M)
reg GasPrice0 _M*
predict MonthlyTrend
replace GasPrice=GasPrice-MonthlyTrend
drop _M* GasPrice0


saveold Data/GasPrices/SpotGasPrice.dta, replace



*********************

/* MERGE */
** Merge ICE and NYMEX
use Data/OilFutures/NYMEX/NYMEXData.dta, clear
sort Year Month
merge Year Month using Data/OilFutures/ICE/ICEData.dta
drop _merge

sort Year Month
merge Year Month using Data/OilFutures/LSCOSpotPrices.dta
drop _merge

** Merge Spot Gas Price
sort Year Month
merge Year Month using Data/GasPrices/SpotGasPrice.dta
drop _merge

** Merge AKS Michigan Survey of Consumers data
	* Thanks to Soren Anderson, Ryan Kellogg, and Jim Sallee for making these data available.
sort Year Month
merge 1:1 Year Month using Data/GasPrices/MSCPaper_AggregateRegressionData.dta, keep(match master) nogenerate keepusing(F5_mean)
rename F5_mean MCSGasPrice
* Deflate from January 2010 to July 2005 dollars
replace MCSGasPrice = MCSGasPrice * .9055957
* Replace with spot gas price when missing
replace MCSGasPrice = GasPrice if MCSGasPrice==.


/* Get R2 of relationship between GasPrices and LSCO Prices*/
* GasPrice is unadjusted.
reg GasPrice LSCOSpot, r
* R2 = .9334

/* TRANSFORM FROM OIL TO GASOLINE PRICE EXPECTATIONS */
/* Transform to monthly observations of futures prices for each future _year_. */

foreach c in ny ice {
egen fprice_`c'0year = rowmean(fprice_`c'1 fprice_`c'2 fprice_`c'3 fprice_`c'4 fprice_`c'5 fprice_`c'6 fprice_`c'7 fprice_`c'8 fprice_`c'9 fprice_`c'10 fprice_`c'11)
drop fprice_`c'? fprice_`c'??
forvalues y = 1/8 {
egen fprice_`c'`y'year = rowmean(fprice_`c'`y'00 fprice_`c'`y'01 fprice_`c'`y'02 fprice_`c'`y'03 fprice_`c'`y'04 fprice_`c'`y'05 fprice_`c'`y'06 fprice_`c'`y'07 fprice_`c'`y'08 fprice_`c'`y'09 fprice_`c'`y'10 fprice_`c'`y'11)
drop fprice_`c'`y'??
}
}
rename fprice_ny900 fprice_ny9year
egen fprice_ice9year = rowmean(fprice_ice900 fprice_ice901)
drop fprice_ice90?

** Compute Transformation of ICE to NYMEX
reg fprice_ny1year fprice_ice1year
local Beta0 = _b[fprice_ice1year]
local Cons0 = _cons

** Compute Transformation of NYMEX to gasoline. The NYMEX contract is equivalent to (i.e. in the same units as, and for the same product) the EIA LSCO data. This is confirmed by showing that fprice_ny1 is basically identical to LSCOSpot.
reg GasPrice LSCOSpot
local Beta1 = _b[LSCOSpot]
local Cons1 = _cons

** Transform to gas price expectations. Either use NYMEX future or the transformed ICE to NYMEX future, then transform to gasoline prices
forvalues y = 0/9 {
gen Eg`y' = cond(fprice_ny`y'year != ., fprice_ny`y'year*`Beta1'+`Cons1' , (fprice_ice`y'year*`Beta0'+`Cons0')*`Beta1' + `Cons1' )
** Rename to be consistent with convention in GetG: the first year of gas costs is paid at the end of the year.
*local y1 = `y' + 1
*rename Eg`y' Eg`y1'
}

keep Year Month GasPrice GasPriceUnadjusted MCSGasPrice Eg?
sort Year Month
saveold Data/GasPrices/GasPriceExpectations.dta, replace

/* FIT EXPONENTIAL DECAY SPECIFICATION */
	* We want to be using seasonally adjusted gas prices here to fit changes in spot gas prices to futures prices - i.e. we don't want to be looking for how quick seasonality decays in futures prices.
	* Although note that using Unadjusted gives mean reversion constant = -0.0956 while using Adjusted gives -0.0952, so it doesn't make a difference.	* So will use unadjusted for simplicity
reshape long Eg, i(Year Month) j(YearsInFuture)
gen logabsEg_150 = log(abs(Eg-1.50))
gen logabsGasPrice_150 = log(abs(GasPrice-1.50))
reg logabsEg_150 logabsGasPrice_150 YearsInFuture if Year>=1991&(Eg>1.50 & GasPrice>1.50)|(Eg<1.50 & GasPrice < 1.50)
local MeanReversionConstant = _b[YearsInFuture]

** Check R^2
gen EgHat = (GasPrice-1.50)*exp(_b[YearsInFuture]*YearsInFuture) + 1.50
reg Eg EgHat if Year>=1999
* R2 = .8365

** Store the MeanReversionConstant in a dataset
clear
set obs 1
gen MeanReversionConstant = `MeanReversionConstant'
saveold Data/GasPrices/MeanReversionConstant.dta,replace

/* PREPARE DATA FOR INSTRUMENT */
use Data/GasPrices/GasPriceExpectations.dta,clear
** Get average prices by the model year calendar, September-August.
* These are seasonally adjusted GasPrice - although does not matter because it is averaged over the year.
replace Year = Year + 1 if Month>=9&Month<=12
collapse (mean) GasPrice GasPriceUnadjusted Eg*, by(Year)
rename Year ModelYear
keep ModelYear GasPrice GasPriceUnadjusted Eg*
sort ModelYear
saveold Data/GasPrices/GasPriceExpectationsInstrument.dta, replace

/* Data for New Vehicle Instrument */
* Seasonally adjusted GasPrice - although does not matter because it is averaged over the year.
clear
set obs 0
save Data/GasPrices/GasPriceExpectationsInstrumentNew.dta, replace emptyok

forvalues ModelYear = 1999/2008 {
	local ModelYear_1 = `ModelYear'-1
	foreach Year in `ModelYear_1' `ModelYear' {	
		local minmonth = 1
		if `Year' == `ModelYear_1' {
			local minmonth = 8
		}
		forvalues Month = `minmonth'/12 {
			use Data/GasPrices/GasPriceExpectations.dta, replace
			display `ModelYear'
			display `Year'
			display `Month'
			keep if ( (Year==`ModelYear'-1&Month>=7) | Year ==`ModelYear' ) & ( (Year<`Year') | ( Year==`Year' & Month < `Month' ) )
			collapse (mean) GasPrice Eg*
			gen ModelYear = `ModelYear'
			gen Year = `Year'
			gen Month = `Month'
			
			append using Data/GasPrices/GasPriceExpectationsInstrumentNew.dta
			save Data/GasPrices/GasPriceExpectationsInstrumentNew.dta, replace
		}
	}
}

foreach var in GasPrice Eg0 Eg1 Eg2 Eg3 Eg4 Eg5 Eg6 Eg7 Eg8 Eg9 {
	rename `var' New`var'
}

* Also generate a NewGasPriceUnadjusted variable, which is the same as the adjusted variable because it's an annual average.
gen NewGasPriceUnadjusted = NewGasPrice

keep ModelYear Year Month NewGasPrice NewGasPriceUnadjusted NewEg*
sort ModelYear Year Month
saveold Data/GasPrices/GasPriceExpectationsInstrumentNew.dta, replace


*************************************
