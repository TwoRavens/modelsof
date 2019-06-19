
clear
set mem 1g
set matsize 5000
set maxvar 5000
set more off

use QCEWindustry_minwage_all.dta


**redoing table 1: Descriptive statistics**************

log using descriptives-11-6-09.txt, replace

gen dummy=1

foreach j in  countypop2000 cntypopdens cntyarea emp_rest_both AWW_rest_both minwage{
table dummy if nonmissing_rest_both==66, c(mean `j' sd `j') 
}


foreach k in ACFSRETAIL RETAIL MFG TOT {
table dummy if nonmissing_`k'==66, c(mean emp`k' sd emp`k' mean AWW`k' sd AWW`k') 
}

sort county
egen temp=group(county) if nonmissing_rest_both==66
egen count_counties=max(temp), by(dummy)

sum count_counties

tab event_type
gen fedevent=1 if event_type==1
egen fedeventspercounty= sum(fedevent), by (county)

gen stateevent=1 if event_type==2
egen steventspercounty= sum(stateevent), by (county)



sum stevents fedevents if nonmissing_rest_both==66 



****descriptives for county-pair sample

set more off
drop _all

use QCEWindustry_minwage_contig.dta

gen dummy=1

foreach j in  countypop2000 cntypopdens cntyarea emp_rest_both AWW_rest_both minwage{
table dummy if nonmissing_rest_both==66, c(mean `j' sd `j') 
}


foreach k in ACFSRETAIL RETAIL MFG TOT {
table dummy if nonmissing_`k'==66, c(mean emp`k' sd emp`k' mean AWW`k' sd AWW`k') 
}

sort county
egen temp=group(county) if nonmissing_rest_both==66
egen count_counties=max(temp), by(dummy)
sum count_counties

sort pair_id
egen temp2= group(pair_id) if nonmissing_both_pair==66
egen count_countypairs=max(temp2), by(dummy)
sum count_countypairs


** calculating the mean number of events  by sample.

tab event_type
gen fedevent=1 if event_type==1
egen fedeventspercounty= sum(fedevent), by (county)

gen fedeventspercounty2= fedeventspercounty/2

gen stateevent=1 if event_type==2
egen steventspercounty= sum(stateevent), by (county)
gen steventspercounty2= steventspercounty/2

sum steventspercounty2 fedeventspercounty2 if nonmissing_rest_both==66 

****Generating Employment Timeseries min-wage versus non-minwage states for Figure 1. 
**D.C. New York, Oregon, Rhode Island, Vermont, Washington, and Wisconsin.

gen scaleminwage="state" if statename=="Alaska"
replace scaleminwage="state" if statename=="California"
replace scaleminwage="state" if statename=="Connecticut"
replace scaleminwage="state" if statename=="Delaware"
replace scaleminwage="state" if statename=="Florida"
replace scaleminwage="state" if statename=="Hawaii"
replace scaleminwage="state" if statename=="Illinois"
replace scaleminwage="state" if statename=="Maine"
replace scaleminwage="state" if statename=="Massachusetts"
replace scaleminwage="state" if statename=="Minnesota"
replace scaleminwage="state" if statename=="New Jersey"
replace scaleminwage="state" if statename=="New York"
replace scaleminwage="state" if statename=="Oregon"
replace scaleminwage="state" if statename=="Rhode Island"
replace scaleminwage="state" if statename=="Vermont"
replace scaleminwage="state" if statename=="Washington"
replace scaleminwage="state" if statename=="Wisconsin"
replace scaleminwage="state" if statename=="District of Columbia"

replace scaleminwage="federal" if scaleminwage==""

gen yearquarter=years+quarters

table yearquarter scaleminwage , c(sum empTOT)


log close

