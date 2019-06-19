********************************************************************************
*************** THIS DO-FILE GENERATES TABLE 4 IN THE MAIN PAPER ***************
********************************************************************************

clear
cap clear all
set more off
set mem 100m


********************************************************
********* GENERATE CONSTRAINT ON EXECUTIVE DATA ********
********************************************************


* Read in the institutional quality data measure 1: the Constraint on the Executive from Polity IV

insheet using "coedata_table4.csv", clear
drop if xconst < 0

* Set 2008 CoE = 2007 CoE

expand 2 if year == 2007
sort country year
quietly by country year:  gen dup = cond(_N==1,0,_n)
replace year = 2008 if dup ==2

gen year1 = string(year)
gen mergeid = country + " " + year1

drop year1

foreach i in 1965 1980{
replace mergeid = subinstr(mergeid,"Yugoslavia `i'","Croatia `i'",1)
}

foreach i in 1982 1985{
replace mergeid = subinstr(mergeid,"Germany West `i'","Germany `i'",1)
replace country = "Germany" if country == "Germany West"
}

tempfile constraint
save `constraint'
clear


*********************************************************
********* GENERATE INVESTMENT PROFILE SCORE DATA ********
*********************************************************


* Read in the institutional quality data measure 2: the Investment Profile Score from the PRS Group

insheet using "ipsdata_table4.csv", clear

forval i = 1984(1)2007 {
  destring y_`i', force replace
}

rename v1 country
reshape long y_, i(country) j(year)

* Generate uniform country names

replace country = subinstr(country,"Congo","Congo Brazzaville",1)
replace country = subinstr(country,"Congo DR","Democratic Rep of Congo",1)
replace country = subinstr(country,"Kazakstan","Kazakhstan",1)
replace country = subinstr(country,"United Kingdom","UK",1)

gen year1 = string(year)
gen mergeid = country + " " + year1

foreach i in 1965 1980{
replace mergeid = subinstr(mergeid,"Yugoslavia `i'","Croatia `i'",1)
}

forval i = 1984(1)1990{
replace mergeid = subinstr(mergeid,"West Germany `i'","Germany `i'",1)
}

* Generate mergeid
drop year year1 country
rename y_ ips

tempfile constraint2
save `constraint2'
clear


*******************************************
******** LOAD IN GDP DEFLATOR DATA ********
*******************************************


insheet using "gdpdeflatordata_table4_corrected.csv", clear
sort year

tempfile factor
save `factor'


*******************************************
************* LOAD IN FDI DATA ************
*******************************************


insheet using "fdidata_table4.csv", clear
reshape long fdi, i(v1) j(year)
gen year1   = string(year)
gen mergeid = v1 + " " + year1
drop  v1 year year1

tempfile fdi
save `fdi'


**************************************************************
************* LOAD IN HYDROCARBON PRODUCTION DATA ************
**************************************************************


insheet using "hydrocarbonproductiondata_table4.csv", clear
reshape long hydprod_, i(v1) j(year)
gen year1   = string(year)
gen mergeid = v1 + " " + year1
rename hydprod_ hydprod
drop  v1 year year1

tempfile production
save `production'


**************************************************************
************* LOAD IN CUMULATIVE PRODUCTION DATA *************
**************************************************************


insheet using "cumproductiondata_table4.csv", clear
reshape long cum_, i(v1) j(year)
gen year1   = string(year)
gen mergeid = v1 + " " + year1
rename cum_ cumprod
drop  v1 year year1

tempfile production2
save `production2'


**************************************************************
******************* LOAD IN POPULATION DATA ******************
**************************************************************


insheet using "populationdata_table4.csv", clear
reshape long pop, i(v1) j(year)

gen year1   = string(year)
gen mergeid = v1 + " " + year1
drop  v1 year year1

tempfile population
save `population'


**************************************************************
***************** LOAD IN EXPROPRIATIONS DATA ****************
**************************************************************


insheet using "expropriationsdata_table4.csv", clear
reshape long expro, i(v1) j(year)

gen year1   = string(year)
gen mergeid = v1 + " " + year1
drop  v1 year year1

tempfile expropriations
save `expropriations'


**************************************************************
********************** LOAD IN GDP DATA **********************
**************************************************************


insheet using "gdpdata_table4.csv", clear

gen year1 = string(year)
gen mergeid = country + " " + year1
rename value gdp_nom

tempfile gdp
save `gdp'


**************************************************************
******************* LOAD IN OIL PRICE DATA *******************
**************************************************************

insheet using "oilpricedata_table4.csv", clear
sort year
drop oilpricenominal
tempfile oilprice
save `oilprice'


**********************************************************
*********** MERGING THE VARIOUS DATA SETS ****************
**********************************************************


* Merge in GDP factor

use `constraint'
sort country year
mmerge year using `factor'      			    // _merge == 1 captures the cases in which we don't have GDP figures for field interest data pre-1970 and post 2008
keep if _merge == 3					   
sort mergeid
tempfile constraint1
save `constraint1'

* Merge in Investment Profile Score

use `constraint1'
mmerge mergeid using `constraint2'
keep if _merge == 3 | _merge == 1   		    // Drop if we don't have both contract data and constraint data
								    // These are country-year combinations for which we don't have any contract data
								    // Also, there is no constraint variable for Brunei.
tempfile constraint2
save `constraint2', replace

* Merge in FDI

use `constraint2'
mmerge mergeid using `fdi'          
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile constraint3
save `constraint3'

* Merge in hydrocarbon production
		     
use `constraint3'
mmerge mergeid using `production'          
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile constraint4
save `constraint4'

* Merge in cumulative hydrocarbon production

use `constraint4'
mmerge mergeid using `production2'          
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile constraint5
save `constraint5'

* Merge in population

use `constraint5'
mmerge mergeid using `population'
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile constraint6
save `constraint6'

* Merge in GDP

use `constraint6'
mmerge mergeid using `gdp'
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile constraint7
save `constraint7'

* Merge in oil price

use `constraint7'
mmerge year using `oilprice'      			   
keep if _merge == 3					   
sort mergeid
tempfile constraint8
save `constraint8'

* Merge in expropriations

use `constraint8'
mmerge mergeid using `expropriations'          
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile constraint9
save `constraint9'


**************************************
******** GENERATE VARIABLES **********
**************************************


* Generate real GDP per capita

gen gdpreal_pop = gdp_nom * gdpfactor
label var gdpreal_pop "Real per Capita GDP"

* Generate hydrocarbon production per capita

gen hydprod_pop = hydprod / pop
label var hydprod_pop "Per Capita Hydrocarbon Production"

* Generate FDI per capita

gen fdi_pop = gdpfactor * fdi / pop
label var fdi_pop "Per Capita FDI Inflow"

replace gdpreal_pop = gdpreal_pop / 1000
replace cumprod  = cumprod / 1000000

* Labeling other variables

label var xconst "Constraint on Executive"
label var cumprod "Cumulative Hydrocarbon Production"
label var ips "Investment Profile Score"
label var oilprice "Real Oil Price"


**************************************
******** REGRESSION ANALYSIS *********
**************************************


drop if xconst < 0


*******************************
*******************************
*********** TABLE 4 ***********
*******************************
*******************************


*******************************
* CONSTRAINT ON THE EXECUTIVE *
*******************************


* Column 1: probit, CoE, average marginal effects, full sample
probit  expro oilprice xconst fdi_pop cumprod
margins, dydx(oilprice xconst fdi_pop cumprod) post
eststo Col1

* Column 2: probit, CoE, with GDP and production, average marginal effects, full sample
probit  expro oilprice xconst fdi_pop cumprod gdpreal_pop hydprod_pop
margins, dydx(oilprice xconst fdi_pop cumprod gdpreal_pop hydprod_pop) post
eststo Col2

* Column 3: probit, CoE, average marginal effects, positive production only
probit  expro oilprice xconst fdi_pop cumprod if cumprod > 0
margins, dydx(oilprice xconst fdi_pop cumprod) post
eststo Col3

* Column 4: probit, CoE, with GDP and production, average marginal effects, positive production only
probit expro oilprice xconst fdi_pop cumprod gdpreal_pop hydprod_pop if cumprod > 0
margins, dydx(oilprice xconst fdi_pop cumprod gdpreal_pop hydprod_pop) post
eststo Col4

   
****************************
* INVESTMENT PROFILE SCORE *
****************************


* Column 5: probit, IPS, average marginal effects, positive production only
probit  expro oilprice ips fdi_pop cumprod if cumprod > 0
margins, dydx(oilprice ips fdi_pop cumprod) post
eststo Col5

* Column 6: probit, IPS, with GDP and production, average marginal effects, full sample
probit  expro oilprice ips fdi_pop cumprod gdpreal_pop hydprod_pop if cumprod > 0
margins, dydx(oilprice ips fdi_pop cumprod gdpreal_pop hydprod_pop) post
eststo Col6

esttab Col1 Col2 Col3 Col4 Col5 Col6 using "Table4_corrected.tex", replace width(\hsize) ///
       nocon se title(Probit Regressions - Determinants of Expropriations) sty(tex) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) noconstant star(* 0.10 ** 0.05 *** 0.01) ///
	   addn("Table reports average probit marginal effects. Columns (1) - (4) use the Constraint on the Executive as the proxy for mu, columns (5) and (6) use the Investment Profile Score. Standard errors in parentheses. * p < 0.10. ** p < 0.05. *** p < 0.01. Columns (1) and (2) include the full sample, columns (3) to (6) include observations with positive hydrocarbon production only.") margin label order (oilprice xconst ips fdi_pop cumprod gdpreal_pop hydprod_pop)
