


set more off


program drop _all


program Clean_survey

	replace relative_usage = "Above average use (top 20-40% energy intensive)" if relative_usage=="Above average use" 
	replace relative_usage = "Low use (top 20% most energy efficient homes)" if relative_usage=="Low use" 
	replace relative_change_in_usage = "Slightly increased (plus 5-15%)" if relative_change_in_usage=="Slightly increased" 
	replace relative_change_in_usage = "Dramatically increased (plus 20% or more)" if relative_change_in_usage=="Dramatically increased"

	foreach var in swimming_pool gas_appliances {
		replace `var'="Yes" if `var'=="true"
		replace `var'="No" if `var'=="false"
		gen `var'1 = 1 if `var'=="Yes"
		replace `var'1 =0 if  `var' =="No"
		drop `var'
		rename `var'1 `var'
			}

	label define yesno 0 "No" 1 "Yes"
	label values swimming_pool gas_appliances yesno 	
			
	gen central_ac = 1 if home_num_ac == "Central Air Conditioning"

	replace home_num_ac=" " if home_num_ac=="Central Air Conditioning"


	foreach var in home_num_ac home_num_people home_num_bedrooms house_type {
		tab `var'
		replace `var'=" " if `var'=="Rather not say"
		destring `var', replace
		tab `var'
		}

	** new variable for ac
	gen have_ac= (home_num_ac>0 & home_num_ac <.)
	replace have_ac =1 if central_ac==1
	replace have_ac=. if home_num_ac==. & central_ac==.
		
		
	** recode to be bedrooms of 4 and above
	replace home_num_bedrooms = 4 if home_num_bedrooms >4 & home_num_bedrooms ~=.

	** encode house type 	
	encode house_type, gen(house_type2)
	drop house_type
	rename house_type2 house_type

	** dummy for freestanding house 
	gen house= 1 if house_type ==4 
	replace house = 0 if house_type ~=4 & house_type <.
		
	foreach var in relative_usage relative_change_in_usage relative_peak_usage {
		tab `var'
		gen `var'1 = `var' if `var' ~="Rather not say"
		encode `var'1, gen(`var'2)
		drop `var' `var'1
		rename `var'2 `var'
		tab `var'
		}
		
		


	egen answered=rownonmiss(home_num_ac-house_type)
	gen answeredsomequestions=(answered~=0)
	drop if answered==0 
	drop answered
	gen answeredpriors=(relative_usage~=.)

	replace central_ac= 0  if central_ac==.  & answeredsome==1 

	sort account_number

	codebook, compact
end















use Data/survey_raw_130213, clear
Clean_survey
gen survey_date = td(13feb2013)
save Data/survey_130213, replace

use Data/survey_raw_060313, clear
Clean_survey
gen survey_date = td(6mar2013)
save Data/survey_060313, replace

use Data/survey_raw_220313, clear
Clean_survey
gen survey_date= td(22mar2013)
save Data/survey_220313, replace

use Data/survey_raw_160513, clear
Clean_survey
gen survey_date = td(16may2013)
save Data/survey_160513, replace


use Data/survey_raw_240913, clear
* new questions added
foreach var in anybody_home owner_type  {
	tab `var'
	gen `var'1 = `var' if `var' ~="Rather not say"
	encode `var'1, gen(`var'2)
	drop `var' `var'1
	rename `var'2 `var'
	tab `var'
	}

* day_occupancy weekly_payments are empty	
drop day weekly
Clean_survey
gen survey_date =td(24sept2013)
save Data/survey_240913, replace

clear


use Data/survey_130213

append using Data/survey_060313

append using Data/survey_220313

append using Data/survey_160513

append using Data/survey_240913

duplicates drop 

duplicates tag account_number, gen(dup)
tab dup

* for households with multiple responses, keep first response to survey question
sort account_number survey_date

collapse (firstnm) relative_usage central_ac relative_change_in_usage relative_peak_usage home_num_ac house_type house have_ac home_num_people home_num_bedrooms gas_appliances swimming_pool anybody_home owner_type answeredpriors answeredsome, by(account_number)

***********


save Data/survey, replace

