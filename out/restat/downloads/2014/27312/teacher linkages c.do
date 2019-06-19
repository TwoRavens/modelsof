***LINK TEACHERS BY NAME, ETHNICITY AND GENDER FOR PRE-2006 YEARS TO 2006 AND LATER ID IN ORDER TO GENERATE TEACHER FIXED EFFECTS
clear all
set more off
set mem 500m


use C:\D\Research\Charter\Houston\HISDdata\DataFiles\Teachers\teacher_small

*SAVE FILE OF 2006 ONLY
keep if year == 2006

*TO AVOID MISMATCHES, DROP ANY TEACHERS WHO HAVE THE SAME NAME, ETHNICITY AND GENDER IN A GIVEN YEAR
*REMOVES 2% OF TEACHERS IN 2006 AND 12% - 14% IN EARLIER YEARS
duplicates tag teacher_fname teacher_lname teacher_female teacher_ethnic year, gen(dup)
sort year
by year: tab dup
drop if dup > 0

sort teacher_fname teacher_lname teacher_female teacher_ethnic
save C:\D\Research\Charter\Houston\HISDdata\DataFiles\Teachers\teacher_small_2006, replace



use C:\D\Research\Charter\Houston\HISDdata\DataFiles\Teachers\teacher_small

*TO AVOID MISMATCHES, DROP ANY TEACHERS WHO HAVE THE SAME NAME, ETHNICITY AND GENDER IN A GIVEN YEAR
*REMOVES 2% OF TEACHERS IN 2006 AND 12% - 14% IN EARLIER YEARS
duplicates tag teacher_fname teacher_lname teacher_female teacher_ethnic year, gen(dup)
sort year
by year: tab dup
drop if dup > 0


*GENERATE NEW ID FOR TEACHERS BY NAME AND GENDER
sort teacher_lname teacher_fname teacher_female teacher_ethnic year
egen teacher_link_id = group(teacher_fname teacher_lname teacher_female)
save temp1, replace

*ADD OBSERVATIONS FOR 2007 USING OBS FROM OTHER YEARS UNTIL WE GET 2007-08 DATA
keep if year == 2006
keep teacher_link_id teacher_newid teacher_fname teacher_lname teacher_ethnic teacher_female
drop if teacher_newid == .
gen year = 2007
save temp_2007_a, replace

use temp1, clear
keep if year == 2008
keep teacher_link_id teacher_newid teacher_fname teacher_lname teacher_ethnic teacher_female
drop if teacher_newid == .
gen year = 2007
append using temp_2007_a
duplicates drop
append using temp1

*DROP OBS WITHOUT TEACHER_LINK_ID
drop if teacher_link_id == .
*egen teacher_min_year = min(year), by(teacher_newid)
*gen teacher_pre_aspire = teacher_min_year <= 2005
*sort tch_number year
*gen teacher_in_2006 = teacher_min_year <= 2006


save temp1, replace

*GENERATE PRE-2006 DATA
keep if year < 2006
gen tch_number = teacher_oldid
duplicates tag tch_number campus year, gen (dup2)
drop if dup2 >0 & dup2 != .
sort tch_number campus year
save  "C:\teacher free riding\teacher_linked_ids_pre.dta", replace


*GENERATE POST-2006 DATA
use temp1, clear
gen tch_number = teacher_newid
drop if tch_number == .

*COLLAPSE TO ONE OBS PER TEACHER --> IT SEEMS THE TEACHER-YEAR MATCHES ARE GREAT SO WE JUST NEED TO IDENTIFY THE TEACHER TO LINK
drop year campus teacher_oldid teacher_degree teacher_exp teacher_ethnic
drop dup
duplicates drop

  *DUE TO MARRIAGES SOME TEACHER NUMBERS APPEAR WITH TWO NAMES.  DROP THESE.
  duplicates tag tch_number, gen(dup)
  drop if dup > 0
  drop dup

sort tch_number
save "C:\teacher free riding\teacher_linked_ids_post.dta", replace


