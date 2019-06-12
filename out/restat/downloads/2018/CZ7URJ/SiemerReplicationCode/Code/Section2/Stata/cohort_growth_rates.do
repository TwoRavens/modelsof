/* Compute growth rates by cohort */ 
clear
set more off



cd "yourpath"
* Note: The data below were constructed in SAS
insheet using "yourworkdirectory/data_cohort_growth_20170403.csv"

tsset ein year 
drop if missing(sic2)

gen quarter=yr_qtr-year*10
sum quarter
keep if quarter==4
tsset ein year

gen firmage=year-start_report_ein

bysort ein: egen min_firmage=min(firmage)
drop if min_firmage<0

drop firstdate_ein lastdate_ein end_report_ein
drop yr_qtr start_report_ein min_firmage quarter

gen lag5_mean_emp_firm=l5.mean_emp_firm
gen lag3_mean_emp_firm=l3.mean_emp_firm



gen growth5y=(mean_emp_firm-lag5_mean_emp_firm)/lag5_mean_emp_firm
gen growth3y=(mean_emp_firm-lag3_mean_emp_firm)/lag3_mean_emp_firm

drop if missing(growth3y) & missing(growth5y) 
save growth5y_20170404, replace





use growth5y_20170404, clear


collapse (mean) growth5y, by(firmage naics)


keep growth5y naics firmage

* Need firmage = firmage -5 because I construct cohort growth in the next 5 year (on average)
replace firmage=firmage-5
drop if firmage<0
/* For older firms (15 years+) compute the growth rate of the "old" bin as there start to be being few firms 
in a given naics-age group, generating extreme observations */
gen old=0
replace old=1 if firmage>15
bysort old naics: egen mean_growth=mean(growth5y)
replace growth5y=mean_growth if firmage>15
drop if firmage>16
drop old mean_growth
save growth_by_age_naics , replace




