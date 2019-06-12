*** Figure 1. Relative Distribution of Attention to Selected Policy Topics in CourtÕs Agenda, per legislature (IX-XVI)


use "dataset for dataverse vers.13.dta" 

drop if legislature == 8
drop if legislature == 17
rename major_topic item
rename legislature unit


* Transform observations into wide-form counts and proportions by item
set more off
* Get a list of the items
tab item
gen count=1
* Below loop matches list of items and must be changed to match different datasets
foreach i of numlist 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 23 {
gen countt`i'=count if `i'==item
} 

* Collapse counters into sums by item and across all items
collapse (sum) count countt*, by(unit)
rename count itemtotal

* Below loop matches list of items
foreach i of numlist 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 23 {
* The denominator below is the sum of all observations across items
gen prop`i' = countt`i'/itemtotal

* To avoid dividing by zero, we need to recode proprotions that equal zero to be very small proprotions
replace prop`i' = .000000000000000001 if prop`i' ==0
}


* We keep only the major categories 1 `"Domestic Macroeconomic Issues"', 5 `"Labor and Employment"'
* 12 `"Law, Crime, and Family Issues"', 16 `"Defense"', 20 `"Government Operations"'

keep unit prop1 prop5 prop12 prop16 prop20 countt1 countt5 countt12 countt16 countt20 


* Graph of Figure 1. Relative Distribution of Attention to Selected Policy Topics in CourtÕs Agenda, per legislature (IX-XVI)
graph bar prop12 prop5 prop20 prop1 prop16 , over (unit)

