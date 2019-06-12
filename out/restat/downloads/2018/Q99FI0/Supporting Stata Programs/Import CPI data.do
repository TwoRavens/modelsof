clear
/* Note: the directory is set in the "Environmental Engel Curves.do" file, which calls on this
	program, and does not need to be set here unless the program is running independently.
	To run this program separetly, be sure to set the directory here." */
	
	
/* Import CPI data.do
-----------------------
This file is part of the Environmental Engel Curves project.  The point of this file is to
import CPI data in order to properly discount all of the expenditure.

It produces monthly, quarterly, and annual CPI files based on raw data imported from .csv files
from census.

Each file will have the CPI for core (c), food/bev (f), electricity (e), gasoline (g),
	and fuel oil and other fuels (o)

All series are downloaded from the BLS website:
Energy	CUSR0000SA0E
All items less food and energy	CUSR0000SA0L1E
Food and beverages	CUSR0000SAF
Food	CUSR0000SAF1
Fuels and Utilities	CUSR0000SAH2
Fuel oil and other fuels	CUSR0000SEHE
Fuel oil	CUSR0000SEHE01
Electricity	CUSR0000SEHF01
Gasoline	CUSR0000SETB01

*/

insheet using "Other Raw Files\CPI 1982-2015.csv", comma names /*This file is
	downloaded from census */
gen quarter = 1 if (month==1|month==2|month==3)
replace quarter = 2 if (month==4|month==5|month==6)
replace quarter = 3 if (month==7|month==8|month==9)
replace quarter = 4 if (month==10|month==11|month==12)

rename core cpi_core
rename food_bev cpi_foodbev
rename fuel cpi_fuel
rename electricity cpi_electricity
rename gasoline cpi_gasoline
rename all cpi_all

/* save montly cpi */
save "Compiled Data Files\monthly cpi.dta", replace

/* save quartly cpi */
preserve
collapse (mean) cpi_core cpi_foodbev cpi_fuel cpi_electricity cpi_gasoline cpi_all, by(quarter year)
save "Compiled Data Files\quarterly cpi.dta", replace
restore

/* save annual cpi */
preserve
collapse (mean) cpi_core cpi_foodbev cpi_fuel cpi_electricity cpi_gasoline cpi_all, by(year)
save "Compiled Data Files\annual cpi.dta", replace
restore
