
clear all

insheet using disaster_news_worldwide.csv

rename v1 country
rename v2 event_month
rename v3 event_day
rename v4 event_year
rename v5 zero_day
rename v6 article_date
cap drop v7-v9

replace country = "UK" if regexm(country, "UK")
replace country = "UK" if regexm(country, "United King")

sort country event_year event_month event_day 

sort country event_year event_month event_day
gen article_month = 1 if regexm(article_date, "Jan")
replace article_month = 2 if regexm(article_date, "Feb")
replace article_month = 3 if regexm(article_date, "Mar")
replace article_month = 4 if regexm(article_date, "Apr")
replace article_month = 5 if regexm(article_date, "May")
replace article_month = 6 if regexm(article_date, "Jun")
replace article_month = 7 if regexm(article_date, "Jul")
replace article_month = 8 if regexm(article_date, "Aug")
replace article_month = 9 if regexm(article_date, "Sep")
replace article_month = 10 if regexm(article_date, "Oct")
replace article_month = 11 if regexm(article_date, "Nov")
replace article_month = 12 if regexm(article_date, "Dec")

gen article_day = regexs(1) if regexm(article_date, "[A-Za-z][A-Za-z][A-Za-z] ([0-9]+)-")
gen article_year = regexs(1) if regexm(article_date, "-([0-9]+)")

destring article_day, replace
destring article_year, replace
drop if article_year==.
destring event_year, replace


gen event_date = mdy(event_month, event_day, event_year)
drop article_date
gen article_date = mdy(article_month, article_day, article_year)

gen t = article_date - event_date
gen count=1

drop article_*
compress

collapse event_month event_day event_year (sum) count,by(country event_date t zero_day)

drop if t>14|t<-14

forvalues x=0/29 {
	gen t_`x' = 0
	replace t_`x' = count if t == `x'-14
}

collapse event_month event_day event_year (sum) t* count, by(country event_date zero_day)

drop t

sort country event_year event_month event_day

compress

egen unique_country_date = group(country event_date zero_day)
reshape long t_, i(unique_country_date) j(date)

replace date = date-14

rename t_ cites
rename date t

sort country event_year event_month event_day t

drop if t<-14|t>14

save All_Event_Cites_worldwide, replace

*************************************************************************************************************************************
*************************************************************************************************************************************
clear all

insheet using disaster_news_g7.csv

replace v5 = 1 if v5==10
rename v1 country
rename v2 event_month
rename v3 event_day
rename v4 event_year
rename v5 zero_day
rename v6 article_date
cap drop v7-v9

replace country = "UK" if regexm(country, "UK")
replace country = "UK" if regexm(country, "United King")

sort country event_year event_month event_day 

sort country event_year event_month event_day
gen article_month = 1 if regexm(article_date, "Jan")
replace article_month = 2 if regexm(article_date, "Feb")
replace article_month = 3 if regexm(article_date, "Mar")
replace article_month = 4 if regexm(article_date, "Apr")
replace article_month = 5 if regexm(article_date, "May")
replace article_month = 6 if regexm(article_date, "Jun")
replace article_month = 7 if regexm(article_date, "Jul")
replace article_month = 8 if regexm(article_date, "Aug")
replace article_month = 9 if regexm(article_date, "Sep")
replace article_month = 10 if regexm(article_date, "Oct")
replace article_month = 11 if regexm(article_date, "Nov")
replace article_month = 12 if regexm(article_date, "Dec")

gen article_day = regexs(1) if regexm(article_date, "[A-Za-z][A-Za-z][A-Za-z] ([0-9]+)-")
gen article_year = regexs(1) if regexm(article_date, "-([0-9]+)")

destring article_day, replace
destring article_year, replace
drop if article_year==.
destring event_year, replace


gen event_date = mdy(event_month, event_day, event_year)
drop article_date
gen article_date = mdy(article_month, article_day, article_year)

gen t = article_date - event_date
gen count=1

drop article_*
compress

collapse event_month event_day event_year (sum) count,by(country event_date t zero_day)

drop if t>14|t<-14

forvalues x=0/29 {
	gen t_`x' = 0
	replace t_`x' = count if t == `x'-14
}

collapse event_month event_day event_year (sum) t* count, by(country event_date zero_day)

drop t
sort country event_year event_month event_day
compress
egen unique_country_date = group(country event_date zero_day)
reshape long t_, i(unique_country_date) j(date)

replace date = date-14

rename t_ cites
rename date t

sort country event_year event_month event_day t

drop if t<-14|t>14

replace country = "USA" if country!="UK" & country!="Japan" & country!="Germany" & country!="France" & country!="Canada" & country!="Italy"

append using All_Event_Cites_worldwide

drop unique_country_date
egen unique_country_date = group(country event_date zero_day)

compress
save All_Event_Cites, replace

**************************************************************************************************************
**************************************************************************************************************

clear all

use All_Event_Cites.dta

sort country event_year event_month event_day t

rename event_month month
rename event_year year
rename event_day day

drop event_date zero_day unique_country_date

***Make 4 day window jump variable
gen pre_shock = t<0 & t>-5
gen post_shock = t>=0 & t<4

egen pre_shock_cites = mean(cites) if pre_shock==1, by(country month day year)
egen post_shock_cites = mean(cites) if post_shock==1, by(country month day year)

egen max_pre = max(pre_shock_cites), by(country month day year)
egen max_post = max(post_shock_cites), by(country month day year)

gen jump = max_post/max_pre

drop pre* post* max*

***Make 15 day window jump variable
gen pre_shock = t<0 & t>=-14
gen post_shock = t>=0 & t<=14

egen pre_shock_cites = mean(cites) if pre_shock==1, by(country month day year)
egen post_shock_cites = mean(cites) if post_shock==1, by(country month day year)

egen max_pre = max(pre_shock_cites), by(country month day year)
egen max_post = max(post_shock_cites), by(country month day year)

gen jump_15 = max_post/max_pre

***Going to keep only the largest shock for each country-month; first collapse to the day level and only keep max jumps
collapse (sum) cites pre_shock_cites post_shock_cites (max) jump jump_15, by(country year month day)

egen max_jump = max(jump_15), by(country year month)
drop if jump_15!=max_jump
drop if country==country[_n-1] & year==year[_n-1] & month==month[_n-1]

**Adjust for 14 days in pre period
replace pre_shock_cites = pre_shock_cites*15/14

encode country, gen(country_code)
gen date=  mdy(month, day, year)
tsset country_code date
tsfill, full

replace year = year(date)
replace month = month(date)
replace day = day(date)

******************************************************************************************************************************
****Here we adjust month of occurence if it happens after the Consensus survey date in each month
merge m:1 year month day using "survey_dates.dta"
drop _merge

gen post_survey_date = survey_date
tsset country_code date
tsfill

replace post_survey_date = l.post_survey_date if month==l.month & post_survey_date==.
replace post_survey_date = 0 if post_survey_date==. 

***Here adjust years/months if disasters were after a survey date
replace date = date+30 if post_survey_date==1
replace year = year(date)
replace month = month(date)

sort country year month jump_15
drop if country==country[_n+1] & year==year[_n+1] & month==month[_n+1]

drop max_jump post_survey date country_code survey_date
drop if country==""

compress
save news_jump_data, replace

**************************************************************************************************************
********Construct Figure 1
clear all

use All_Event_Cites.dta

sort country event_year event_month event_day t

rename event_month month
rename event_year year
rename event_day day

drop zero_day unique_country_date

***Keep only countries in our survey data
keep if country=="USA"| country=="Argentina"| country=="Australia"| country=="Austria"| country=="Belgium"| country=="Brazil"| country=="Bulgaria"| country=="Canada"| country=="Chile"| country=="China"| country=="Colombia"| country=="Czech Republic"| country=="Denmark"| country=="Finland"| country=="France"| country=="Germany"| country=="Greece"| country=="Hungary"| country=="India"| country=="Indonesia"| country=="Ireland"| country=="Israel"| country=="Italy"| country=="Japan"| country=="Latvia"| country=="Lithuania"| country=="Malaysia"| country=="Mexico"| country=="Netherlands"| country=="New Zealand"| country=="Norway"| country=="Pakistan"| country=="Peru"| country=="Philippines"| country=="Poland"| country=="Portugal"| country=="Romania"| country=="Russia"| country=="Singapore"| country=="Slovenia"| country=="South Africa"| country=="Spain"| country=="Sweden"| country=="Switzerland"| country=="Taiwan"| country=="Thailand"| country=="Turkey"| country=="UK"| country=="Ukraine"| country=="Venezuela"

***Make 14 day window jump variable
gen pre_shock = t<0 & t>-15
gen post_shock = t>=0 & t<15

egen pre_shock_cites = mean(cites) if pre_shock==1, by(country month day year event_date)

egen pre_normalization = mean(pre_shock_cites), by(country month day year event_date)

replace cites = cites/pre_normalization

collapse cites, by(t)

label var cites "Number of Articles (Relative to Pre-Period Average)"

twoway bar cites t, xlabel(-14(2)14) xtitle("Days Before or After Natural Disaster") ylabel(0(.5)4)
graph export  pre_post_news_articles.png, height(600) width(900) replace
