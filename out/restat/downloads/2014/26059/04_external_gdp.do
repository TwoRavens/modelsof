
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: GDP, EXTERNAL DATA 
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."


*** GDP 1910-2008

insheet using "$datapath\external\txt\gdp_19102008.txt"

forvalues i = 1/100 {
ren v`i' gdp`i-1'
}

forvalues i = 1/100 {
	forvalues n = 1910/2008 {
		local i = `i'+1
		ren gdp`i' gdp`n'
	}
	continue, break
}

ren gdp1 country

reshape long gdp, i(country) j(yrbirth3)
format gdp %9.2f

sort yrbirth3 country
save "$datapath\external\dta\GDP.dta", replace

