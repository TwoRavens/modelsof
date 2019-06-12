
/**THIS PROGRAM CREATES THE BROADBAND AVAILABILITY DATA**

Raw Data Sources:
-477 data downloaded from FCC 477 filing data website on October 27, 2010
-Zip code list, Zip Code geographic size from Census 2000 website

last update to this do-file: 10-4-2016
*/


cd $datafolder


/*Read In Zip Code Access Data*/


/* Read in Zip Code Broadband Data (FCC) */

insheet using "int121999.txt", clear
	rename zipcode zip
	rename numberofholdingcompanies providers
	replace providers="2" if providers=="*"
	destring providers, replace
	gen year=1999
	keep zip providers year
	gen month=12
save "int121999.dta", replace

forvalues Y=2000(1)2004 { 
	local data int12`Y'
	insheet using "`data'.txt", clear
	rename zipcode zip
	rename numberofholdingcompanies providers
	replace providers="2" if providers=="*"
	destring providers, replace
	gen year=`Y'
	keep zip providers year
	gen month=12
	save "`data'.dta", replace
}

forvalues Y=2005(1)2007 {
	local data int12`Y'
	insheet using "`data'.txt", clear
	keep v1 v2 v3
	rename v1 state
	rename v2 zip
	rename v3 providers
	drop if state=="Pr" | state=="Nu" | state=="Fo" | state=="as" | state=="So" | state=="St"
	drop if state=="Pre" | state=="Num" | state=="For" | state=="as" | state=="Sou" | state=="Sta"
	replace providers="2" if providers=="*"
	destring providers, replace
	destring zip, replace
	gen year=`Y'
	keep zip providers year
	gen month=12
	save "`data'.dta", replace
}

foreach Y in 00 01 03{
local data int06`Y'
	insheet using "`data'.txt", clear
	rename zipcode zip
	rename numberofholdingcompanies providers
	replace providers="2" if providers=="*"
	destring providers, replace
	gen year=2000+`Y'
	keep zip providers year
	gen month=6
	save "`data'.dta", replace
	}


import excel "HZIP0602.xls", sheet("Sheet1") cellrange(A2:C25141) firstrow clear
	rename ZipCode zip
	rename NumberofHoldingCompanies providers
	replace providers="2" if providers=="*"
	destring providers, replace
	destring zip, replace
	gen year=2002
	keep zip providers year
	gen month=6
	save "int0602.dta", replace
	

import excel "hzip0604.XLS", sheet("Sheet1") cellrange(A2:D28374) firstrow clear
	rename ZipCode zip
	rename NumberofHoldingCompanies providers
	replace providers="2" if providers=="*"
	destring providers, replace
	destring zip, replace
	gen year=2004
	keep zip providers year
	gen month=6
	save "int0604.dta", replace
	

foreach n in 5 6 8 {
import delimited "hzip060`n'.csv", clear 
	drop if v1=="State Abbreviation"
	drop if v2=="ZIP Code"
	drop if v3=="Number of Holding Companies"
	rename v1 state
	rename v2 zip
	rename v3 providers
	replace providers="2" if providers=="*"
	destring providers, replace
	destring zip, replace
	gen year=200`n'
	keep zip providers year
	gen month=6
	save "int060`n'.dta", replace
	}
	
	
insheet using "int0607.txt", clear
drop if v1=="-"
drop if v1==""
	keep v1 v2 v3
	rename v1 state
	rename v2 zip
	rename v3 providers
	replace providers="2" if providers=="*"
	destring providers, replace
	destring zip, replace
	gen year=2007
	keep zip providers year
	gen month=6
	save "int0607.dta", replace
	

