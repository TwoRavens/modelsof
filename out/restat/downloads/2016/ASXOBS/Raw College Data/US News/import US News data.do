*** year_of_pub is date US News issue was published (e.g. 2009==Sept 1, 2009)
*** Data are collected one year earlier (e.g. if year_of_pub==2009, the data come from 2008)

set more off
insheet using "Merged US News.csv", comma
destring acceptance_rate, replace
destring top10pct, replace
destring alumni_giving_rate, replace
save usnews_data.dta, replace
