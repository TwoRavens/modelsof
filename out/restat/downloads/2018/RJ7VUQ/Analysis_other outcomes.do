version 8.2
capture clear
capture log close
set more off
set mem 5000m
set mat 2000


use "Data/Enterprise surveys/Enterprise surveys_judicial_reforms_microdata.dta", replace

label variable reform_dum4_post "Judicial reform * Post" 
label variable reform_dum4_post_DJ4g1m  "Judicial reform * Post * Specific" 

replace va_perwo_ppp_trim1 =va_perwo_ppp_trim1 /1000
label variable va_perwo_ppp_trim1 "Value added per worker (Thousand dollars)"
local lab : var label va_perwo_ppp_trim1

xi: reg va_perwo_ppp_trim1 reform_dum4_post reform_dum4_post_DJ4g1m i.post*DJ4g1m  i.countryname*DJ4g1m i.sector i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap , robust cluster(countryname)
sum va_perwo_ppp_trim1 if reform_dum4==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Results/Analysis_final_alloutcomes7.tex", tex addtext(Country fixed effects, YES, 3-digit sector FE, YES, Controls, YES) keep(reform_dum4_post reform_dum4_post_DJ4g1m) adec(2) addstat("Mean control group", `mean_dep_var', "SD control group", `sd_dep_var') label bdec(2) se sdec(2) ctitle("Value added per worker") replace

label variable va "Value Added" 
/*
revenue minus cost of intermediate inputs
va=d2-n2b-n2c-n2d-n2e-n2f-n2g-n2h
*/
label variable n7_perwo_ppp_trim1 "Capital stock per worker" 
/*
Just manufacturing sector
If this establishment had to hypothetically purchase the land and buildings, and machinery and equipment in
use now, as they are in their current condition, how much would it cost to purchase each of the following?
LCUs
a. Machinery vehicles, and equipment n7a
b. Land and buildings n7b
in ppp, trimmed 1 percent
*/
label variable prop_skill "Proportion of skilled workers" 
/*
Just manufacturing sector
l4a/l3a
number full-time employees Skilled production workers / number Production workers
*/
label variable size_num "Number employees" 
*total number of employees (adjusted for part-time)
label variable new_firm "New firm" 
*new_firm=1 if firm created after baseline

local list_outcomes va profit n7_perwo_ppp_trim1 prop_skill size_num new_firm 

foreach var of local list_outcomes{

local lab : var label `var'

xi: reg `var' reform_dum4_post reform_dum4_post_DJ4g1m i.post*DJ4g1m  i.countryname*DJ4g1m i.sector i.DJ4g1m*dtf i.DJ4g1m*foreign_aid2_percap , robust cluster(countryname)
sum `var' if reform_dum4==0
local mean_dep_var=r(mean)
local sd_dep_var=r(sd)
outreg2 using "Results/Analysis_final_alloutcomes7.tex", tex addtext(Country fixed effects, YES, 3-digit sector FE, YES, Controls, YES) keep(reform_dum4_post reform_dum4_post_DJ4g1m)  label bdec(2) se sdec(2) ctitle("`lab'") append

*adec(2) addstat("Mean control group", `mean_dep_var', "SD control group", `sd_dep_var')
}


exit
