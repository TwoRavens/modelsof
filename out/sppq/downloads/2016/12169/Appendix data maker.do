*use "/Users/terry/Dropbox/Postvra policies paper/Data/Final data/state budget analysis master dataset (temp).dta", clear
use "/Users/terry/Dropbox/Postvra policies paper/Data/Final data/state budget analysis master dataset (temp submission version).dta", clear

drop if propwelf==.
keep state statealphaid year propwelf rgrantsHK rpyHK dist race_prop age_prop metro_prop demcon_HK med1 confederate propregblack lt pt

replace rgrantsHK = rgrantsHK/1000
label variable propwelf "(Husted and Kenny) Proportion of state spending devoted to welfare"
label variable demcon_HK  "(Husted and Kenny) Democratic control of state government index"
label variable pt  "(Husted and Kenny) Presence of poll tax"
label variable lt  "(Husted and Kenny) Presence of literacy test"
label variable rgrantsHK  "(Husted and Kenny) Real federal grants"
label variable rpyHK  "(Husted and Kenny) Real personal income per capita"
label variable age_prop  "(Husted and Kenny) Proportion of state population 65+"
label variable metro_prop  "(Husted and Kenny) Proportion of state population in a metro area"
label variable race_prop  "(Husted and Kenny) Proportion of population black"
label variable propregblack "(Husted and Kenny) Proportion of registrants Af Am"





save "/Users/terry/Dropbox/Postvra policies paper/Replication files/Appendix data.dta", replace
