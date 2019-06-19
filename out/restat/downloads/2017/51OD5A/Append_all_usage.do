program drop _all

* define program to clean each updated of the energy usage data

program Clean_usage

	* cleaning file to be called after energy_use_intervals_raw_DATE.dta has been loaded, see Append_all_usage
	* cleans energy usage data, removes people who sell back to the grid, 
	* removes initial observations, tags large users


	* Registers that start with B (instead of E or Q) represent energy put back into the grid
	* Registers that start with E are controlled load customers.
	gen regtype=substr(register,1,1)
	gen controlledload=register=="E2"
	gen sellback=(regtype=="B")
	by account_number, sort: egen hh_sellback=sum(sellback)
	keep if hh_sellback==0

	drop if regtype=="Q"

	rename read_date read_date_raw
	gen read_date=date(read_date_raw,"YMD")
	gen read_year=year(read_date)
	gen read_month=month(read_date)
	gen read_week=week(read_date)
	gen read_dow=dow(read_date)
	label var read_dow "Day of week"
	label define dowvals 0 "Sunday" 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday"
	label values read_dow dowvals

	sort account_number read_date

	egen dailykWh = rowtotal(interval1-interval48)
	gen ones=1

	collapse (sum) dailykWh registers=ones controlledload (first) regtype read_date_raw read_year read_month read_week read_dow, by(account_number read_date)
	label var dailykWh "kWh per day"

	* Tag large users (robustness change cut off, 273kWh/day is definition of small users in the NEM)
	gen large_use1=0
	by account_number, sort: replace large_use1=1 if dailykWh>273 & dailykWh ~=.
	label var large_use1 "Daily usage exceeded 273kWh"

	* Alternative definition of large user
	gen large_use2=0
	by account_number, sort: replace large_use2=1 if dailykWh>50 & dailykWh~=.
	label var large_use2 "Daily usage exceeded 50kWh"

	* Large_user has at least one daily usage exceeding the threshold
	gen large_user1=0
	by account_number, sort: egen ind_large =sum(large_use1)
	replace large_user1 =1 if ind_large>0 & ind_large~=.

	drop ind_large

	gen large_user2=0
	by account_number, sort: egen ind_large =sum(large_use2)
	replace large_user2 =1 if ind_large>0 & ind_large~=.

	drop ind_large

	sort account_number read_date
	by account_number: drop if _n==1

end























































clear
set more off

*******
* second update of usage file
use Data/energy_use_intervals_raw_040613, clear
Clean_usage
gen sample=3
save Data/daily_040613, replace

*******
* first update of usage file
use Data/energy_use_intervals_raw_220313, clear
Clean_usage
gen sample=2
save Data/daily_220313, replace


*******
* original usage file
use Data/energy_use_intervals_raw_130213, clear
Clean_usage
gen sample=1
save Data/daily_130213, replace

*******

* append updates to original
append using Data/daily_040613
append using Data/daily_220313

save Data/daily_all, replace

* dailykwh large user status, controlled load or registers can vary between samples - seems to be some typos in earlier data (i.e. missing decimal places)

* take most recent meter read then second most recent meter read
gen temp = 1 if sample==3
gen temp2 = 1 if sample==2

sort account_number read_date temp temp2

collapse (first) daily registers controlledload large_use1 large_use2 large_user1 large_user2 sample, by(account_number read_date)

save Data/temp_daily, replace

use Data/energy_use_intervals_raw_040613, clear

collapse (first) nmi, by(account_number)

merge 1:m account_number using Data/temp_daily

drop if _merge==1

drop _merge

gen control2= 1 if nmi>= 6102999999 & nmi< 6104000000
replace control2=0 if control2==.

save Data/daily, replace

erase Data/temp_daily.dta
