**MERGES GRADUATION DATA FOR ALL YEARS INTO A SINGLE DATASET

clear
set mem 700m
set more off


cd Graduation

*1993-94
use g9394
gen year = 1993
local year = 1994
foreach file in "9495" "9596" "9697" "9798" "9899" "9900" "0001" "0102" "0203" "0304" "0405" "0506" {
  append using G`file'
  replace year = `year' if year == .
  local year = `year' + 1
}
keep id year
sort id year
gen graduated = 1
drop if id == .
duplicates drop
 


save graduates, replace


/*


foreach file in "9394" "9495" "9596" "9697" "9798" "9899" "9900" "0001" "0102" "0203" "0304" "0405" "0506" {
  capture use G`file'
  destring, replace
  save, replace
}