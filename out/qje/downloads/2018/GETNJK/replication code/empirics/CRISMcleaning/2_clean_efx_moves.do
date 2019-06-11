/*
Uses Equifax files to keep track of when CIDs "move" addresses or zipcodes.
-	Records move indicator when address date variable changes
-	Records previous zip and address code, next zip and next address code for each month
-	Records indicators for a move in +/- 3m, +/- 6m, +6m, +12m
Input: ./temp/full`x'_efx.dta
Output: ./temp/cid_moves`x'.dta, ./temp/cid_moves.dta (all appended)
*/ 


set more off
clear

foreach y of global list {

use temp/full`y'_efx.dta, clear
keep cid as_of_mon_id addr_dt_datem zipcode addr_code
sort cid as_of_mon_id 
gen move = addr_dt_datem[_n-1] ~= addr_dt_datem & cid == cid[_n-1]
destring zipcode, replace
gen prev_zip = zipcode[_n-1] if move
replace prev_zip = prev_zip[_n-1] if ~move & prev_zip[_n-1] ~= . & cid == cid[_n-1]
gen prev_addrcode = addr_code[_n-1] if move
replace prev_addrcode = addr_code[_n-1] if ~move & addr_code[_n-1] ~= "" & cid == cid[_n-1]

drop move
gsort cid -as_of_mon_id
gen move = addr_dt_datem[_n-1] ~= addr_dt_datem & cid == cid[_n-1]
gen next_addr_datem = addr_dt_datem[_n-1] if move
gen next_zip = zipcode[_n-1] if move
replace next_zip = next_zip[_n-1] if ~move & next_zip[_n-1] ~= . & cid == cid[_n-1]
gen next_addrcode = addr_code[_n-1] if move
replace next_addrcode = addr_code[_n-1] if ~move & next_addrcode[_n-1] ~= "" & cid == cid[_n-1]
replace next_addr_datem = next_addr_datem[_n-1] if ~move & addr_dt_datem[_n-1] ~= . & cid == cid[_n-1]
drop move
gen movepm3m = (as_of_mon_id - addr_dt_datem < 3) | (next_addr_datem - as_of_mon_id < 3)
gen movepm6m = (as_of_mon_id - addr_dt_datem < 6) | (next_addr_datem - as_of_mon_id < 6)
gen movep6m = (as_of_mon_id - addr_dt_datem == 0) | (next_addr_datem - as_of_mon_id < 6)
gen movep12m = (as_of_mon_id - addr_dt_datem == 0) | (next_addr_datem - as_of_mon_id < 12)
save temp/cid_moves`y'.dta, replace
}

clear
foreach y of global list {
cap append using temp/cid_moves`y'.dta
}
save temp/cid_moves.dta, replace
