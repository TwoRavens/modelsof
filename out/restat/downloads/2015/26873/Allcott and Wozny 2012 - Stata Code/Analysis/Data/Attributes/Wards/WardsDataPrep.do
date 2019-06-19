/* WardsDataPrep.do */
/* This prepares the Wards characteristics data. */

clear
gen ModelYear=.
save WardsAttributes.dta, replace


/* Cycle Through Years and Prepare Data */

forvalues year = 1984/2008 {

local car = 0
local truck = 0
local import = 0

*** Imports
if `year' <= 1995 {

local import = 1
clear
insheet using Import_`year'.csv, comma
gen int ModelYear = `year'
gen Truck = .

include ColumnNameAdjustments.do
include WardsWorksheetPrep.do

append using WardsAttributes.dta
save WardsAttributes.dta,replace
local import = 0
}



*** Cars 
local car = 1
clear
insheet using Car_`year'.csv, comma
gen int ModelYear = `year'
gen Truck = 0

include ColumnNameAdjustments.do
include WardsWorksheetPrep.do

append using WardsAttributes.dta
save WardsAttributes.dta,replace
local car = 0

**** Trucks
clear
local truck = 1
insheet using Truck_`year'.csv, comma
gen int ModelYear = `year'
gen Truck = 1
include ColumnNameAdjustments.do
include WardsWorksheetPrep.do
append using WardsAttributes.dta
save WardsAttributes.dta,replace
local truck = 0 

} /* This closes the `year' loop */




/* Fix Typos & Change Category in order to merge data */
save WardsAttributes.dta, replace
do CleanWardsNames.do


/* Eliminate missing observations */
* Don't do this for Traction, ABS, or Stability: 0s are meaningful.
foreach var in HP Torque Weight MPGCity MPGHwy Wheelbase MSRP {
replace `var' = . if `var'==0
*gen sd`var' = `var'
}

* drop if (HP==.| Weight==.)

/* Outsheet for Matchups
sort Make Model ModelYear Drive Cylinders Liters ModelYear
outsheet using Data/Matchups/Wards.csv, comma names replace
*/

/* Change Liters to 10*Liters for merging */
replace Liters=Liters*10
recast int Liters, force

/* Get MSRP in 2005 dollars */
* use the deflator for March of that model year, as this is roughly the middle of the sales period.
rename ModelYear Year
gen Month = 3
sort Year Month
merge Year Month using ../../CPI/MonthlyCPI.dta, keep(CPIDeflator) nokeep
replace MSRP = MSRP/CPIDeflator
rename Year ModelYear
drop Month _merge CPIDeflator

/* Collapse, Sort, and Save */
/*
collapse (mean) Weight HP MPGCity MPGHwy MSRP Wheelbase Truck (sd) sdWeight sdHP sdMPGCity sdMPGHwy sdMSRP sdWheelbase, by(Make Model ModelYear Drive Cylinders Liters)

keep Make Model Drive Cylinders Liters ModelYear Weight HP MSRP Wheelbase Truck MPG*
order Make Model Drive Cylinders Liters ModelYear Weight HP MSRP Wheelbase Truck
*/

replace Make=upper(Make)
replace Model=upper(Model)
replace Submodel=upper(Submodel)
replace Trim=upper(Trim)
rename Submodel BodyStyle
rename Cylinders Cylinder
sort Make ModelYear Trim BodyStyle Cylinder Liters Drive
gen WardsID = _n
sort WardsID
saveold WardsAttributes.dta,replace
/* outsheet using WardsAttributes.csv, comma replace */

*
*
