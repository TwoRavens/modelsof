********************************************************************************************
*******This file merges and saves in format needed for matlab estimations
********************************************************************************************



*****Eight types

***Open Wage Time Series
use "$data/tswage.dta", clear

***merge to supply time series
merge 1:1 year ltypes using "$data/tssupply.dta"


sort year ltypes
keep year ltypes lnwinc lnsupply

reshape wide lnwinc lnsupply, i(year) j(ltypes)

***save full panel dataset
save "$data/final_panel.dta", replace

***produce csv
use "$data/final_panel.dta", clear


			
***preserve, sort, produce state and survey vector IT of specific ltype
preserve
sort year
keep year
outsheet using "$output/eighttype/T.csv", delimiter(";") nonames replace
restore

***preserve, sort, produce dependend variable wage Y vector of specific ltype
preserve
sort year 
keep lnwinc*
outsheet using "$output/eighttype/Y.csv", delimiter(";") nonames replace
restore

***preserve, sort, produce dependend variable sum of workers (weighted by hours
***worked (as are lweekly) vector of specific ltype
preserve
sort year
keep lnsupply*
outsheet using "$output/eighttype/X.csv", delimiter(";") nonames replace
restore





*****Two types

***Open Wage Time Series
use "$data/tswage_two_type.dta", clear

***merge to supply time series
merge 1:1 year ltypestwo using "$data/tssupply_two_type.dta"


sort year ltypestwo
keep year ltypestwo lnwinc lnsupply

reshape wide lnwinc lnsupply, i(year) j(ltypestwo)

*** save full panel dataset
save "$data/final_panel_two_type.dta", replace

***produce csv
use "$data/final_panel_two_type.dta", clear


			
***preserve, sort, produce state and survey vector IT of specific ltype
preserve
sort year
keep year
outsheet using "$output/twotype/T.csv", delimiter(";") nonames replace
restore

***preserve, sort, produce dependend variable wage Y vector of specific ltype
preserve
sort year 
keep lnwinc*
outsheet using "$output/twotype/Y.csv", delimiter(";") nonames replace
restore

***preserve, sort, produce dependend variable sum of workers (weighted by hours
***worked (as are lweekly) vector of specific ltype
preserve
sort year
keep lnsupply*
outsheet using "$output/twotype/X.csv", delimiter(";") nonames replace
gen dXagg=lnsupply2-lnsupply1
keep dXagg
outsheet using "$output/twotype/dXagg.csv", delimiter(";") nonames replace
restore

