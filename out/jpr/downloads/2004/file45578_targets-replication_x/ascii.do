clear
set mem 15m
set more off

use "C:\My Documents\leaders\data\leadtarg3.dta"

sort ccode year startobs

drop startobs endobs eindate eoutdate leader

outfile using "C:\My Documents\leaders\data\leadtarg3.raw", replace
