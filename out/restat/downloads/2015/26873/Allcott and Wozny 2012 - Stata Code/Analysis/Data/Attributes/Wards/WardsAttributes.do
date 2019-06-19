/*************************************************************************
* WardsAttributes.do
* Merge Wards attributes to the master prefix file.  This requires
* WardsPrefix.csv.  An automated version of this is produced by WardsMatchSmart.do.
* This can read that file directly, or a manually edited version of it.
*************************************************************************/

capture log close
log using WardsAttributes.log, replace

set more off
clear all
set mem 500m

/* Get fixed matchups */
insheet using WardsPrefix.csv, comma names
drop if prefixid==.
keep matchvin810 wardsid
rename matchvin810 MatchVin810
rename wardsid WardsID
drop if WardsID==0

/* Merge to get CarIDs */
sort MatchVin810
merge MatchVin810 using ../../Matchups/Prefix810, unique nokeep keep(CarID ModelYear)
/* In the future, we should allow unmatched
   vehicles, then guess the quantities based on some type of imputation. */
tab _merge
drop if _merge==1
drop _merge

/* Merge to Attributes dataset */
sort WardsID
merge WardsID using WardsAttributes, uniqusing nokeep keep(HP Weight Wheelbase MPGCity MPGHwy MSRP Torque Traction ABS Stability Truck)
assert _merge==3 | WardsID==.
drop _merge WardsID

/* This is Sounman's old code, so these may not apply now. */
/* TRUCK & IMPORT */
/*

** Truck
replace Truck=1 if (VClass=="SUV"|VClass=="SPV"|strpos(VClass,"Pickup")!=0|strpos(Model,"Pickup")!=0|strpos(Model,"Truck")!=0|strpos(VClass,"Minivan")!=0|strpos(VClass,"Van")!=0)
replace Truck=0 if (strpos(VClass,"ompact")!=0|strpos(VClass,"Two-Seat")!=0|strpos(VClass,"Mid")!=0|strpos(VClass,"Large")!=0)
** Manual Key-in
replace Truck=0 if Truck==. & Make=="Amc/Eagle" & Model=="Spirit"
replace Truck=0 if Truck==. & Make=="Audi" & Model=="Super 90"
replace Truck=0 if Truck==. & Make=="Bmw" & Model=="2002"
replace Truck=0 if Truck==. & Make=="Buick" & Model=="Apollo"
replace Truck=0 if Truck==. & Make=="Cadillac" & strpos(Model,"Fleetwood")!=0
replace Truck=0 if Truck==. & Make=="Fiat" & Model=="850"
replace Truck=0 if Truck==. & Make=="Honda" & Model=="Honda 600"
replace Truck=0 if Truck==. & Make=="Mercedes-Benz" & (Model=="220"|Model=="250")
replace Truck=0 if Truck==. & Make=="Nissan/Datsun" & Model=="610"
replace Truck=0 if Truck==. & Make=="Opel" & (Model=="1900"|Model=="Kadett")
replace Truck=0 if Truck==. & Make=="Pontiac" & strpos(Model,"Ventura")==1
replace Truck=0 if Truck==. & Make=="Porsche" & Model=="914"
replace Truck=0 if Truck==. & Make=="Toyota" & (Model=="Celica Supra"|Model=="Crown")
replace Truck=0 if Truck==. & Make=="Volkswagen" & (Model=="411"|Model=="412"|Model=="Squareback")
replace Truck=0 if Truck==. & Make=="Volvo" & (Model=="144"|Model=="164")
replace Truck=1 if Truck!=1 & Truck!=0 & Make=="Suzuki" & Model=="Sidekick"
*/

/* Impute missing data */

/* Collapse to CarID level */
/* We should modify this to collapse weighted by Polk quantities (when new, presumably) and on
   2WD / AWD percentages. */
* Get Harmonic Means of MPG
gen GPMHwy = 1/MPGHwy
gen GPMCity = 1/MPGCity

collapse (mean) HP Weight Wheelbase GPMCity GPMHwy MSRP Truck Torque Traction ABS Stability, by(CarID ModelYear)


** Some of the trucks have truck > 0 and Truck <1. These are the Aztek, the C1500, etc - all trucks. So name them all trucks
replace Truck = 1 if Truck > 0 & Truck <1


gen MPGHwy = 1/GPMHwy
gen MPGCity = 1/GPMCity
drop GPMCity GPMHwy

/* Assume missing ABS, Traction, and Stability means 0 */
foreach var in ABS Traction Stability {
		replace `var' = 0 if `var'==.
}

/* Impute missing values of Torque */
foreach var in HP Weight Wheelbase MPGHwy MPGCity MSRP {
		gen `var'_msg = (`var'==.)
		gen `var'_imp = cond(`var'_msg,0,`var')
		assert `var'_msg<. & `var'_imp<.
}

reg Torque HP_imp HP_msg Weight_imp Weight_msg Wheelbase_imp Wheelbase_msg MPGHwy_imp MPGHwy_msg MPGCity_imp MPGCity_msg MSRP_imp MSRP_msg
predict TorqueHat
replace Torque = TorqueHat if Torque==.
assert Torque<.
drop TorqueHat
foreach var in HP Weight Wheelbase MPGHwy MPGCity MSRP {
		drop `var'_imp `var'_msg
}

gen InWards=1
sort CarID ModelYear
saveold WardsByPrefix, replace
