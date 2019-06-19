*** append and merge data from people searches

**1. append all months from people search A

clear

use Data/Aug12peopleA_raw.dta

append using Data/Sep12peopleA_raw.dta

append using Data/Oct12peopleA_raw.dta

append using Data/Nov12peopleA_raw.dta

append using Data/Dec12peopleA_raw.dta

append using Data/Jan13peopleA_raw.dta

append using Data/Feb13peopleA_raw.dta

append using Data/Mar13peopleA_raw.dta

append using Data/Apr13peopleA_raw.dta

append using Data/May13peopleA_raw.dta

append using Data/Jun13peopleA_raw.dta

append using Data/Jul13peopleA_raw.dta

append using Data/Aug13peopleA_raw.dta

** update received and opened data (Yann's webuse ends in June 2013)

append using Data/Jul13_rece_peopleA_raw.dta

append using Data/Aug13_rece_peopleA_raw.dta

rename clickedcampaignemail NClicked
rename openedcampaignemail NEmailOpen
rename receivedcampaignemail NEmailSent

sort customerid date 

save Data/webuse_part1.dta, replace

**1. merge all months from people search B (ever did something not panel of actions)
** id is KissMetrics id variable
** customerid is either email address or account number

merge m:1 id customerid using Data/ACCNOsemail_raw.dta
drop _merge

merge m:1 id customerid using Data/ActivatedpeopleB_raw.dta
drop _merge

merge m:1 id customerid using Data/LoggedinpeopleB_raw.dta
drop _merge

merge m:1 id customerid using Data/ClickedpeopleB_raw.dta
drop _merge

merge m:1 id customerid using Data/VisitedpeopleB_raw.dta
drop _merge

merge m:1 id customerid using Data/ReceivedpeopleB_raw.dta
drop _merge

merge m:1 id customerid using Data/PeopleB_raw.dta
drop _merge

merge m:1 id customerid using Data/Viewingconserve_raw.dta
drop _merge

*** clean up date variables

foreach var in clicked_date visited_date {
	replace `var'=substr(`var',1,10)
	gen `var'_date = date(`var', "YMD")
	drop `var'
	rename `var'_date `var'
	replace date =mofd(`var') if date==.
	}

	
foreach var in activated_date loggedin_date received_date opened_date{
	replace `var'=substr(`var',1,10)
	gen `var'_date = date(`var', "DMY")
	drop `var'
	rename `var'_date `var'
	replace date =mofd(`var') if date==.
	}
	
format  clicked_date activated_date loggedin_date visited_date opened_date received_date %d	
	
* fill in account numbers recorded in customer id variables (manually checked that this is the case)

gen x=real(customerid) if length(customerid)==6
replace account_number =x if account_number==.
replace account_number =x if account_number<10000 
drop x 

order id customerid account_number date received_date opened_date clicked_date NClicked activated_date activated Totalloggedin loggedin_date Totalvisits visited_date month year  


** drop observations of website visits without any other info (customerid is not email or account number, appears to be randomly generated string for anonymous users in KM documentation)

egen todrop = rownonmiss(received-loggedin_date)

* drop customerids with missings and zeros (no account_numbers)
 drop if account_number==. & todrop ==1

 * customers with only visits (no account_numbers or email addresses)
drop if todrop ==0

drop todrop

* use id file to match more account numbers
merge m:1 id customerid using Data/people_id, keepusing(accountnumber)
drop if _merge==2
drop _merge
replace account_number = accountnumber if account_number ==.

order id account_number accountnumber account_number_first customerid customer_first 

sort account_number date

** some account numbers have multiple ids, collapse using customerid and fill in account numbers by customerid

collapse  (lastnm) id  (first) account_number_first (firstnm) ever_viewedconserve id1=id account_number date NEmailOpen NEmailSent received_date opened_date clicked_date NClicked activated_date Totalloggedin loggedin_date Totalvisits visited_date month year , by(customerid)

* manually update some incorrect account numbers (from manual KissMetrics search)
replace account_number = 175284 if id==16676
replace account_number = 158529 if id==15660
replace account_number = 206692 if id ==38867
replace account_number =206973 if id==58367
replace account_number =137416  if id==58465

save Data/people_webuse.dta, replace

* export a list of customerids without account numbers
keep if account_number ==. 

collapse (first) id first_date = date (last) last_date=date, by(customerid)
outsheet using KissMetrics/Kissmissingaccounts.csv, comma replace

use Data/people_webuse.dta, clear

* now collapse to get panel

collapse (first) account_number_first customerid (firstnm) ever_viewedconserve account_number id1 NEmailOpen NEmailSent received_date opened_date clicked_date NClicked activated_date Totalloggedin loggedin_date Totalvisits visited_date month year , by(id date)

drop if account_number ==.

xtset account_number date

save Data/people_webuse.dta, replace

foreach month in Aug Sep Oct Nov Dec {
	erase Data/`month'12peopleA_raw.dta 
		}

foreach month in Jan Feb Mar Apr May Jun Jul Aug {
	erase Data/`month'13peopleA_raw.dta 
		}

erase Data/Jul13_rece_peopleA_raw.dta
erase Data/Aug13_rece_peopleA_raw.dta

erase Data/ACCNOsemail_raw.dta
erase Data/ActivatedpeopleB_raw.dta
erase Data/LoggedinpeopleB_raw.dta

erase Data/ClickedpeopleB_raw.dta
erase Data/VisitedpeopleB_raw.dta
erase Data/ReceivedpeopleB_raw.dta
erase Data/PeopleB_raw.dta





