*Data files for California teacher salaries and benefits for individual years for 2004-2013 in .exe format are available at: http://www.cde.ca.gov/ds/fd/cs/

*For each of the 10 years, follow this procedure (this syntax is for 2004, the 2003-2004 Fiscal Year data file)
*Import the .exe file into Stata
gen year=2004
*Create 7 digit code that uniquely identifies each school disrict in California 
gen cds7=cds
*Variable that indicates the % change over prior year's average salary in school district
gen teach=ts1_pctchange
keep cds7 year teach
*Save the trimmed data file

*Append individual year files together for 2004-2013

*Merge with election data using "cds7 year"
