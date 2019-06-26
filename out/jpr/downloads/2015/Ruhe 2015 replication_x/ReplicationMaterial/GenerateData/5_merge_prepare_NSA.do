* prepare Non State Actor Dataset

cd "`w_dir'"

set more off


insheet using "nsa_v3.4_21November2013.asc", clear





*generate stata friendly start date variables
gen start_year = substr(startdate,1,4)
gen start_month = substr(startdate,6,2)
gen start_day = substr(startdate,9,2)

*check that procedure works correctly
list startdate start_* in 1/20
tab start_year, miss
tab start_month, miss
tab start_day, miss

*apparently there are problematic cases
list dyadid startdate if start_month=="1-" | start_month=="3-" | start_month=="8-"
replace start_day = substr(startdate,8,1) if start_month=="1-" | start_month=="3-" | start_month=="8-"
replace start_month = substr(startdate,6,1) if start_month=="1-" | start_month=="3-" | start_month=="8-" 

*check that procedure works correctly
list startdate start_* in 1/20
tab start_year, miss
tab start_month, miss
tab start_day, miss

*turn into numeric values
destring start_year, gen(start_year_n)
destring start_month, gen(start_month_n)
destring start_day, gen(start_day_n)

*drop string variables
drop start_year start_month start_day

*rename numerical variables
rename start_year_n start_year
rename start_month_n start_month
rename start_day_n start_day

*gen stata compatible start date
gen start_date = mdy(start_month, start_day, start_year)

*making user-friendly common date format
format start_date %td

*check that procedure worked correctly
list startdate start_date in 1/20






*generate stata friendly end date variables
gen end_year = substr(enddate,1,4)
gen end_month = substr(enddate,6,2)
gen end_day = substr(enddate,9,2)

*check that procedure works correctly
list enddate end_* in 1/20
tab end_year, miss
tab end_month, miss
tab end_day, miss

*apparently there are problematic cases
list dyadid enddate if end_month=="2-" | end_month=="3-" | end_month=="5-" | end_month=="6-"
replace end_day = substr(enddate,8,2) if end_month=="2-" | end_month=="3-" | end_month=="5-" | end_month=="6-"
replace end_month = substr(enddate,6,1) if end_month=="2-" | end_month=="3-" | end_month=="5-" | end_month=="6-" 

*check that procedure works correctly
list enddate end_* in 1/20
tab end_year, miss
tab end_month, miss
tab end_day, miss

*turn into numeric values
destring end_year, gen(end_year_n)
destring end_month, gen(end_month_n)
destring end_day, gen(end_day_n)

*drop string variables
drop end_year end_month end_day

*rename numerical variables
rename end_year_n end_year
rename end_month_n end_month
rename end_day_n end_day

*gen stata compatible start date
gen end_date = mdy(end_month, end_day, end_year)

*making user-friendly common date format
format end_date %td

*check that procedure worked correctly
list enddate end_date in 1/20







*recode start date as monthly date indicator
generate start=mofd(start_date)		
format start %tm

*recode end date as monthly date indicator
generate end=mofd(end_date)
format end %tm


*two dyads are potentially problematic, since they have the same id
list if dyadid==686
drop if dyadid==686


*turn data into dyad-month format
gen id=_n
gen diff=end-start+1
expand diff
gen date=start
bysort id: replace date=date+_n-1
format date %tm
list id dyadid side_a start end date in 1/50


*sort data
sort date
sort dyadid, stable


*extract year
gen daydate=dofm(date)
gen year=yofd(daydate)
drop daydate


*keep only relevant years
keep if year>1992
keep if year<2005


*there is an instances in which a dyad-month occures twice
list dyadid start_date end_date date if dyadid[_n]==dyadid[_n-1] & date[_n]==date[_n-1]
list in 1819/1820
*apparently, this case changed in the middle of a month and this leads to 
*duplicate observation: one for the old and another for the new characteristics
*to get rid of these duplicates, only the new characteristics are kept
drop in 1819


*generate unique dyad id to enable merging with GED data
gen dyad_unique = 10000 + dyadid
rename date month


*declare panel dataset
xtset dyad_unique month


*save 
local sysdate = c(current_date)
save "NSA_`sysdate'.dta", replace




