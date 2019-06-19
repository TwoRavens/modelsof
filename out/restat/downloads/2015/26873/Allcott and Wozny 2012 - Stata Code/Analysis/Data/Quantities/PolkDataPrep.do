/* PolkDataPrep.do */
/* This file prepares the RL Polk Data. */

/* Insheet Data and Name Variables */
* Liters needs to be double for the match to work properly, so the insheet must be double.
insheet using Data/Quantities/PolkRegistrations.csv, comma names clear double

do Data/Quantities/CleanPolkNames.do


/* Transmission */
rename mantranspct PctManual 
* Drop any observations where auto and manual percentages don't equal one. (This is primarily to eliminate a large number of observations where both are zero.)
gen TotalPct = PctManual + autotranspct
replace PctManual = . if TotalPct != 1
drop TotalPct

/* Collapse vehicles that are same: this includes a collapse of GVW, the AWD and 4x4 Drive types, as well as the BodyStyle changes. */
* collapse (mean) PctManual reg2003 reg2004 reg2005 reg2006 reg2007 reg2008, by(Make Model Trim Cylinders Liters FuelType BodyStyle Drive ModelYear)
* NB can't do "collapse" command because we can't deal with missing values 

egen Group = group(Make Model Trim Cylinders Liters FuelType BodyStyle Drive ModelYear),missing

bysort Group: egen meanPctManual = mean(PctManual)
drop PctManual 
rename meanPctManual PctManual

forvalues var = 2003/2008 {
bysort Group: egen sumreg`var' = sum(reg`var')
drop reg`var'
rename sumreg`var' reg`var'
}

sort Group
drop if Group==Group[_n-1]


/* Sort and Save */
order Make Model Cylinders Liters Drive FuelType BodyStyle ModelYear Trim PctManual reg* 
keep Make Model Cylinders Liters Drive FuelType BodyStyle ModelYear Trim PctManual reg* 
sort Make Model Cylinders Liters Drive FuelType BodyStyle ModelYear 
save Data/Quantities/PolkRegistrations.dta, replace

/*To generate the original template for the matchups spreadsheet:
collapse (sum) reg2003, by(Make Model Trim BodyStyle)
sort Make Model Trim BodyStyle
outsheet using Data/Matchups/Polk.csv, comma names replace

*/

