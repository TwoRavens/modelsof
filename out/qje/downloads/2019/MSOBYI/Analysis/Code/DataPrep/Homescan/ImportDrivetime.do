/* ImportDrivetime.do */
* This imports the drivetime csv file, saves it, and imputes missing data. Imputation added by Hunt 9-29-2015.


******************************************************************************
/* Import drivetimes.csv */
import delimited $Externals/Data/DriveTime/drivetimes_2018.csv, clear case(preserve)
* drop one duplicate
duplicates tag Store_Location_ID HMS_Location_ID, gen(dup)
drop if dup==1 & duration==.
keep Store_Location_ID HMS_Location_ID duration
merge 1:1 Store_Location_ID HMS_Location_ID using $Externals/Calculations/Homescan/StoreHouseLatLong.dta, ///
	keep(match master using) nogen // NB this is missing the top row due to programming error, but otherwise complete and full match
save $Externals/Calculations/Homescan/DriveTime.dta, replace

*import delimited $Externals/Data/DriveTime/drivetimes_add.csv, clear case(preserve)
*append using $Externals/Calculations/Homescan/DriveTime.dta

replace duration=duration/60
drop if HMS_Location_ID==.|Store_Location_ID==.

/* Impute missing drivetimes */	
reg duration Store_Distance
predict durationhat
replace duration = durationhat if duration==.
drop durationhat

rename duration DriveTime

save $Externals/Calculations/Homescan/DriveTime.dta, replace


