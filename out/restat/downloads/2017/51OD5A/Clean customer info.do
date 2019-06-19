* cleans customer_info_raw.dta
* identifies treatment, plan types, also overlaps on some survey data (household characteristics)


clear
set more off

use Data/customer_info_raw

rename accountno account_number
sort account_number

foreach x in gasappliances swimmingpool {
replace `x'="0" if `x'=="FALSE"
replace `x'="0" if `x'=="No"
replace `x'="1" if `x'=="TRUE"
replace `x'="1" if `x'=="Yes"
}

rename noofac ac
rename noofpeople people
rename noofbedrooms bedrooms

gen central_air =  1 if ac=="Central Air Conditioning"
replace ac ="0" if central_air ==  1

foreach x in ac people bedrooms swimmingpool gasappliances{
	replace `x'="" if `x'=="Rather not say"
	destring `x', replace
}

* Convert all other survey responses to numerical
foreach x in opened received clicked {
	replace `x'campaignemail="" if `x'campaignemail=="#N/A"
	destring `x'campaignemail, replace
	}
gen opened_date=date(firstopenedcampaignemail,"DM20Y")

* collapse to remove duplicates, take the first non missing value
* potentially lose firstopenedcampaignemail and ignoring differences in nextbilldate
collapse (firstnm) opened_date openedcampaignemail receivedcampaignemail clickedcampaignemail ///
	ac central_air people bedrooms swimmingpool gasappliances (first) firstopenedcampaignemail nextbilldate, ///
	by(account_number planname priceplancode emailfrequency firstreading)

duplicates list

* Plan types
gen ratetype=""
replace ratetype="flat" if strmatch(priceplancode,"*GDGR*")
replace ratetype="TOU" if strmatch(priceplancode,"*GHGL*")
gen plantype=""
replace plantype="Quick" if strmatch(planname,"*Quick*")
replace plantype="Easy" if strmatch(planname,"*Easy*")
replace plantype="Early" if strmatch(planname,"*Early*")
replace plantype="Honeymoon" if strmatch(planname,"*Honeymoon*")
replace plantype="Business" if strmatch(planname,"*Business*")
replace plantype="Natural" if strmatch(planname,"*Natural*")		// Green energy plan
replace plantype="Shine" if strmatch(planname,"*Shine*")		    // Solar panel plan


save Data/customer_info, replace

