*Data files for Adequate Yearly Progress for individual years for 2004-2013 in .txt format are available at: http://www.cde.ca.gov/ta/ac/ay/aypdatafiles.asp

*For each of the 10 years, follow this procedure (this syntax is for 2004)
*Import the .txt file into Stata
gen year=2004
keep if rtype=="D"
*Create 7 digit code that uniquely identifies each school disrict in California 
gen cds_string=string(cds)
gen cds7_string=substr(cds_string,1,7)
destring cds7_string, gen(cds7)
keep cds7 year epp_wh epp_aa epp_hi mpp_wh mpp_aa mpp_hi
*Save the trimmed data file

*Append individual year files together for 2004-2013

*Merge with election data using "cds7 year"


*********************************************************************************************************************


*Data files that include the % of students who are African American, Hispanic, and eligible for free or subsidized meals (for supplemental analysis) in the district are available at http://www.cde.ca.gov/ta/ac/ap/apidatafiles.asp
*Use the "20XX Base API Data File" data sets

*For each of the 10 years, follow this procedure (this syntax is for 2004)
*Import the .txt file into Stata
gen year=2004
keep if rtype=="D"
*Create 7 digit code that uniquely identifies each school disrict in California 
gen cds_string=string(cds)
gen cds7_string=substr(cds_string,1,7)
destring cds7_string, gen(cds7)
keep cds7 year pct_aa pct_hi meals
*Save the trimmed data file

*Append individual year files together for 2004-2013

*Merge with election data using "cds7 year"
