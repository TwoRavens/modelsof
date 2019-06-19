********************************************************************************
*********** THIS DO-FILE GENERATES TABLES 2 AND 3 IN THE MAIN PAPER ************
********************************************************************************

clear
cap clear all
set more off
set mem 100m

****************************************************************************
******************** GENERATE CONTRACT STUCTURE DATA ***********************
****************************************************************************

* Read in country - field - country specific contract and reserves data

insheet using "woodmacdata.csv"

* Generate country (regime) - field (asset) - company file

replace regimeassetcompany = subinstr(regimeassetcompany,"(K-Factor)","",1)    // Get rid of "K-Factor" label in Algeria
replace regimeassetcompany = subinstr(regimeassetcompany,"Congo-","Congo ",1)  // Deal with naming of Congo
gen dash1   = strpos(regimeassetcompany,"-")			                       // Finds position of the first dash
gen regime  = substr(regimeassetcompany,1,dash1-1)
gen rest    = substr(regimeassetcompany,dash1+1,.)
gen dash2   = strpos(rest,"-")	
gen asset   = substr(rest,1,dash2-1)
gen company = substr(rest, dash2+1,.)
drop dash1 dash2 rest

replace regime = subinstr(regime,"(National Companies)","",1)
replace regime = subinstr(regime,"(LNG)","",1)
replace regime = trim(regime)									 // Delete trailing blanks

gen abc1 = reverse(regime)
gen abc2 = strpos(abc1," ")
gen abc3 = length(regime)
gen country = substr(regime,1,abc3-abc2)
replace regime = substr(regime,abc3-abc2+1,.)
drop abc*

order regimeassetcompany country regime asset company
label var country "Country"
label var regime "Regime"
label var asset "Asset (Field Name)"
label var company "Company"

* Generate Revenue variables
rename v11 revenue_50
label var revenue_50 "Revenue at $50 per barrel"

* Generate mergeid
gen year1 = string(startyearfieldinterests)
gen mergeid = country + " " + year1
replace mergeid = subinstr(mergeid,"Malaysia Thailand JDA","Malaysia",1)   
replace mergeid = subinstr(mergeid,"Kirgizstan","Kyrgyzstan",1)
drop year1

* Remove divide by zero from gammaoil
replace gammaoil = subinstr(gammaoil,"#DIV/0!","-9999",1)
destring(gammaoil),replace
replace gammaoil = . if gammaoil == -9999

* Remove divide by zero from gammaoil
replace gamma = subinstr(gamma,"#DIV/0!","-9999",1)
destring(gamma),replace
replace gamma = . if gammaoil == -9999

tempfile assets
save `assets'
clear


********************************************************
********* GENERATE CONSTRAINT ON EXECUTIVE DATA ********
********************************************************


* Read in the institutional quality data measure 1: the Constraint on the Executive from Polity IV

insheet using "coedata.csv"

* Generate uniform country names

replace country = subinstr(country,"Congo Kinshasa","Democratic Rep of Congo",1)
replace country = subinstr(country,"United Kingdom","UK",1)
replace country = subinstr(country,"Myanmar (Burma)","Myanmar",1)

* Assume that 2008 CoE = 2007 CoE

expand 2 if year == 2007
sort country year
quietly by country year:  gen dup = cond(_N==1,0,_n)
replace year = 2008 if dup ==2

* Generate mergeid
gen year1 = string(year)
gen mergeid = country + " " + year1

drop year year1 country

foreach i in 1965 1980{
replace mergeid = subinstr(mergeid,"Yugoslavia `i'","Croatia `i'",1)
}

foreach i in 1982 1985{
replace mergeid = subinstr(mergeid,"Germany West `i'","Germany `i'",1)
}

tempfile constraint
save `constraint'
clear


*********************************************************
********* GENERATE INVESTMENT PROFILE SCORE DATA ********
*********************************************************


* Read in the institutional quality data measure 2: the Investment Profile Score from the PRS Group

insheet using "ipsdata.csv", clear

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


insheet using "gdpdeflatordata.csv", clear
rename year startyearfieldinterests
sort startyearfieldinterests

tempfile factor
save `factor'


*******************************************
************* LOAD IN FDI DATA ************
*******************************************


insheet using "fdidata.csv", clear
reshape long fdi, i(v1) j(year)
gen year1   = string(year)
gen mergeid = v1 + " " + year1
drop  v1 year year1

tempfile fdi
save `fdi'


**************************************************************
************* LOAD IN HYDROCARBON PRODUCTION DATA ************
**************************************************************


insheet using "hydrocarbonproductiondata.csv", clear
reshape long hydprod_, i(v1) j(year)
gen year1   = string(year)
gen mergeid = v1 + " " + year1
rename hydprod_ hydprod
drop  v1 year year1
replace mergeid = subinstr(mergeid,"Kirgizstan","Kyrgyzstan",1)

tempfile production
save `production'


**************************************************************
************* LOAD IN CUMULATIVE PRODUCTION DATA *************
**************************************************************


insheet using "cumproductiondata.csv", clear
reshape long cum_, i(v1) j(year)
gen year1   = string(year)
gen mergeid = v1 + " " + year1
rename cum_ cumprod
drop  v1 year year1
replace mergeid = subinstr(mergeid,"Kirgizstan","Kyrgyzstan",1)

tempfile production2
save `production2'


**************************************************************
******************* LOAD IN POPULATION DATA ******************
**************************************************************


insheet using "populationdata.csv", clear
reshape long pop, i(v1) j(year)

gen year1   = string(year)
gen mergeid = v1 + " " + year1
drop  v1 year year1

replace mergeid = subinstr(mergeid,"Democratic Republic of the Congo","Democratic Rep of Congo",1)
replace mergeid = subinstr(mergeid,"Libyan Arab Jamahiriya","Libya",1)
replace mergeid = subinstr(mergeid,"United Kingdom","UK",1)
replace mergeid = subinstr(mergeid,"Viet Nam","Vietnam",1)

tempfile population
save `population'


**************************************************************
********************** LOAD IN GDP DATA **********************
**************************************************************


insheet using "gdpdata.csv", clear

gen year1 = string(year)
gen mergeid = countryorarea + " " + year1
rename value gdp_nom
replace mergeid = subinstr(mergeid,"Democratic Republic of the Congo","Democratic Rep of Congo",1)
replace mergeid = subinstr(mergeid,"Libyan Arab Jamahiriya","Libya",1)
replace mergeid = subinstr(mergeid,"United Kingdom of Great Britain and Northern Ireland","UK",1)
replace mergeid = subinstr(mergeid,"Viet Nam","Vietnam",1)

tempfile gdp
save `gdp'


**********************************************************
*********** MERGING THE VARIOUS DATA SETS ****************
**********************************************************


* Merge in GDP deflator

use `assets'
sort startyearfieldinterests
mmerge startyearfieldinterests using `factor'      // _merge == 1 captures the cases in which we don't have GDP figures for field interest data pre-1970 and post 2008							         
sort mergeid
tempfile assets1
save `assets1'

* Merge in Constraint on the Executive Index

use `assets1'
mmerge mergeid using `constraint'
keep if _merge == 3					    // Drop if we don't have both contract data and constraint data
								    // These are country-year combinations for which we don't have any contract data
								    // Also, there is no constraint variable for Brunei.								    
tempfile assets2
save `assets2'

* Merge in Investment Profile Score

use `assets2'
mmerge mergeid using `constraint2'
keep if _merge == 3 | _merge == 1   // Drop if we don't have both contract data and constraint data
								    // These are country-year combinations for which we don't have any contract data
								    // Also, there is no constraint variable for Brunei.								    
tempfile assets3
save `assets3', replace

* Merge in hydrocarbon production

use `assets3'
mmerge mergeid using `production'          
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile assets4
save `assets4'

* Merge in cumulative hydrocarbon production

use `assets4'
mmerge mergeid using `production2'          
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile assets5
save `assets5'

* Merge in population

use `assets5'
mmerge mergeid using `population'
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile assets6
save `assets6'

* Merge in GDP

use `assets6'
mmerge mergeid using `gdp'
keep if _merge == 3					     // Drops observations for years in countries for which we have no new contracts
tempfile assets7
save `assets7'

* Merge in FDI

use `assets7'
mmerge mergeid using `fdi'
keep if _merge == 3					     // Drop observations for years in countries for which we have no new contracts
tempfile assets8
save `assets8'


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

replace gdpreal_pop = gdpreal_pop / 1000000
replace cumprod  = cumprod / 1000000

* Labeling other variables

label var xconst "Constraint on Executive"
label var cumprod "Cumulative Hydrocarbon Production"
label var ips "Investment Profile Score"


**************************************
******** REGRESSION ANALYSIS *********
**************************************


drop if revenue_50 < 0						// Drop fields with negative revenues
drop if totalremainingreservesmmboe ==0 			// Drop fields with no remaining reserves
drop if pipeline == 1	       				// Drop pipeline "fields"
drop if xconst < 0
destring(gamma), replace


*******************************
*******************************
*********** TABLE 2 ***********
*******************************
*******************************


*******************************
* CONSTRAINT ON THE EXECUTIVE *
*******************************


* Column 1: OLS, CoE, regular standard errors
reg gamma xconst fdi_pop cumprod
eststo Col1

* Column 1: OLS, CoE, standard errors at the country-year level
reg gamma xconst fdi_pop cumprod, cluster(mergeid)
eststo Col1_2

* Column 2: WLS, CoE
wls0 gamma xconst fdi_pop cumprod, wvar(totalremainingreservesmmboe) type(abse)
eststo Col2

preserve

keep if iocorforeignnoc == 1

* Column 3: OLS, CoE, IOCs only, regular standard errors
reg gamma xconst fdi_pop cumprod
eststo Col3

* Column 3: OLS, CoE, IOCs only, standard errors at the country-year level
reg gamma xconst fdi_pop cumprod, cluster(mergeid)
eststo Col3_2

* Column 4: WLS, CoE, IOCs only
wls0 gamma xconst fdi_pop cumprod ,wvar(totalremainingreservesmmboe) type(abse)
eststo Col4

restore


****************************
* INVESTMENT PROFILE SCORE *
****************************


preserve

keep if iocorforeignnoc == 1

* Column 5: OLS, IPS, IOCs only, regular standard errors
reg gamma ips fdi_pop cumprod
eststo Col5

* Column 5: OLS, IPS, IOCs only, standard errors at the country-year level
reg gamma ips fdi_pop cumprod, cluster(mergeid)
eststo Col5_2

* Column 6: WLS, IPS, IOCs only
wls0 gamma ips fdi_pop cumprod ,wvar(totalremainingreservesmmboe) type(abse)
eststo Col6

restore

esttab Col1 Col1_2 Col2 Col3 Col3_2 Col4 Col5 Col5_2 Col6 using "Table2.tex", ///
       replace width(\hsize) nocon se title(Contract Structure Regressions - Dependent Variable: gamma(60)) sty(tex) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) noconstant star(* 0.10 ** 0.05 *** 0.01) ///
	   addn("Columns (1) - (4) use the Constraint on the Executive as the proxy for mu, columns (5) and (6) use the Investment Profile Score. Standard errors in parentheses and clustered at the country-year level (used for stars) in [ ]. WLS weighting by remaining barrels of oil equivalent. * p < 0.10. ** p < 0.05. *** p < 0.01. Columns (1) and (2) include the full sample, columns (3) to (6) include IOC only.") label order(xconst ips fdi_pop cumprod)


*******************************
*******************************
*********** TABLE 3 ***********
*******************************
*******************************


*******************************
* CONSTRAINT ON THE EXECUTIVE *
*******************************


* Column 1: OLS, CoE, with GDP and production, regular standard errors
reg gamma xconst fdi_pop cumprod gdpreal_pop hydprod_pop
eststo Col1

* Column 1: OLS, CoE, with GDP and production, standard errors at the country-year level
reg gamma xconst fdi_pop cumprod gdpreal_pop hydprod_pop, cluster(mergeid)
eststo Col1_2

* Column 2: WLS, CoE, with GDP and production
wls0 gamma xconst fdi_pop cumprod gdpreal_pop hydprod_pop,wvar(totalremainingreservesmmboe) type(abse)
eststo Col2

preserve

keep if iocorforeignnoc == 1

* Column 3: OLS, CoE, with GDP and production, IOCs only, regular standard errors
reg gamma xconst fdi_pop cumprod gdpreal_pop hydprod_pop
eststo Col3

* Column 3: OLS, CoE, with GDP and production, IOCs only, standard errors at the country-year level
reg gamma xconst fdi_pop cumprod gdpreal_pop hydprod_pop, cluster(mergeid)
eststo Col3_2

* Column 4: WLS, CoE, with GDP and production, IOCs only
wls0 gamma xconst fdi_pop cumprod gdpreal_pop hydprod_pop,wvar(totalremainingreservesmmboe) type(abse)
eststo Col4

restore


****************************
* INVESTMENT PROFILE SCORE *
****************************


preserve

keep if iocorforeignnoc == 1

* Column 5: OLS, IPS, with GDP and production, IOCs only, regular standard errors
reg gamma ips fdi_pop cumprod gdpreal_pop hydprod_pop
eststo Col5

* Column 5: OLS, IPS, with GDP and production, IOCs only, standard errors at the country-year level
reg gamma ips fdi_pop cumprod gdpreal_pop hydprod_pop, cluster(mergeid)
eststo Col5_2

* Column 6: WLS, IPS, with GDP and production, IOCs only
wls0 gamma ips fdi_pop cumprod gdpreal_pop hydprod_pop,wvar(totalremainingreservesmmboe) type(abse)
eststo Col6

restore

esttab Col1 Col1_2 Col2 Col3 Col3_2 Col4 Col5 Col5_2 Col6 using "Table3.tex", ///
       replace width(\hsize) nocon se title(Contract Structure Regressions - Dependent Variable: gamma(60)) sty(tex) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) noconstant star(* 0.10 ** 0.05 *** 0.01) ///
	   addn("Columns (1) - (4) use the Constraint on the Executive as the proxy for mu, columns (5) and (6) use the Investment Profile Score. Standard errors in parentheses and clustered at the country-year level (used for stars) in [ ]. WLS weighting by remaining barrels of oil equivalent. * p < 0.10. ** p < 0.05. *** p < 0.01. Columns (1) and (2) include the full sample, columns (3) to (6) include IOC only.") label order(xconst ips fdi_pop cumprod)
