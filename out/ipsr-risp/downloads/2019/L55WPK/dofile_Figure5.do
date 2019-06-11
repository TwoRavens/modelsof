**** Figure 5. AgendasÕ Entropy of Parliament and Court, per years (1983-2013)


** Attention allocation across macrotopics 1983-2013 - Constitutional Court

use "dataset for dataverse vers.13.dta"

drop if legislature == 8
drop if legislature == 17
rename major_topic item
rename yearnum unit

* Transform observations into wide-form counts and proportions by item
set more off
* Get a list of the items
tab item
gen count=1
* Below loop matches list of items and must be changed to match different datasets
foreach i of numlist 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 23 {
* Create counters for observations within items
gen countt`i'=count if `i'==item
} 

* Collapse counters into sums by item and across all items
collapse (sum) count countt*, by(unit)
rename count itemtotal

* Below loop matches list of items
foreach i of numlist 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 23 {
* The denominator below is the sum of all observations across items
gen prop`i' = countt`i'/itemtotal
* To avoid dividing by zero, we need to recode proprotions that equal zero to be very small proprotions (see paper for more on this point)
replace prop`i' = .000000000000000001 if prop`i' ==0
}

* We calculate the shannon's H
gen shannonsh = ///
-(((prop1*ln(prop1))+ /// 
(prop2*ln(prop2))+ ///
(prop3*ln(prop3))+ ///
(prop4*ln(prop4))+ ///
(prop5*ln(prop5))+ ///
(prop6*ln(prop6))+ ///
(prop7*ln(prop7))+ ///
(prop8*ln(prop8))+ ///
(prop9*ln(prop9))+ ///
(prop10*ln(prop10))+ ///
(prop12*ln(prop12))+ ///
(prop13*ln(prop13))+ ///
(prop14*ln(prop14))+ ///
(prop15*ln(prop15))+ ///
(prop16*ln(prop16))+ ///
(prop17*ln(prop17))+ ///
(prop18*ln(prop18))+ ///
(prop19*ln(prop19))+ ///
(prop20*ln(prop20))+ ///
(prop21*ln(prop21))+ ///
(prop23*ln(prop23))))

* We calculate the normalized shannon's H
gen normshannonsh = (shannonsh/ln(21))
 
* We rename the variables 
rename countt1 countt1_court
rename countt2 countt2_court
rename countt3 countt3_court
rename countt4 countt4_court
rename countt5 countt5_court
rename countt6 countt6_court
rename countt7 countt7_court
rename countt8 countt8_court
rename countt9 countt9_court
rename countt10 countt10_court
rename countt12 countt12_court
rename countt13 countt13_court
rename countt14 countt14_court
rename countt15 countt15_court
rename countt16 countt16_court
rename countt17 countt17_court
rename countt18 countt18_court
rename countt19 countt19_court
rename countt20 countt20_court
rename countt21 countt21_court
rename countt23 countt23_court

rename prop1 prop1_court
rename prop2 prop2_court
rename prop3 prop3_court
rename prop4 prop4_court
rename prop5 prop5_court
rename prop6 prop6_court
rename prop7 prop7_court
rename prop8 prop8_court
rename prop9 prop9_court
rename prop10 prop10_court
rename prop12 prop12_court
rename prop13 prop13_court
rename prop14 prop14_court
rename prop15 prop15_court
rename prop16 prop16_court
rename prop17 prop17_court
rename prop18 prop18_court
rename prop19 prop19_court
rename prop20 prop20_court
rename prop21 prop21_court
rename prop23 prop23_court

rename shannonsh shannonsh_court
rename normshannonsh normshannonsh_court

save "shannon corte.dta"
 

*** Attention allocation across macrotopics 1983-2013 - Parliament

use "dataset laws.dta"
drop if rif_leg == 8
drop if rif_leg == 17
rename major_topic item
rename year_adoption unit

* Transform observations into wide-form counts and proportions by item, note that we have 21, non-sequential items in this example
set more off
* Get a list of the items
tab item
gen count=1
* Below loop matches list of items and must be changed to match different datasets
foreach i of numlist 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 23 {
* Create counters for observations within items
gen countt`i'=count if `i'==item
} 

* Collapse counters into sums by item and across all items
collapse (sum) count countt*, by(unit)
rename count itemtotal

* Below loop matches list of items
foreach i of numlist 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 21 23 {
* The denominator below is the sum of all observations across items
gen prop`i' = countt`i'/itemtotal
* To avoid dividing by zero, we need to recode proprotions that equal zero to be very small proprotions (see paper for more on this point)
replace prop`i' = .000000000000000001 if prop`i' ==0
}



* We calculate the shannon's H

gen shannonsh = ///
-(((prop1*ln(prop1))+ /// 
(prop2*ln(prop2))+ ///
(prop3*ln(prop3))+ ///
(prop4*ln(prop4))+ ///
(prop5*ln(prop5))+ ///
(prop6*ln(prop6))+ ///
(prop7*ln(prop7))+ ///
(prop8*ln(prop8))+ ///
(prop9*ln(prop9))+ ///
(prop10*ln(prop10))+ ///
(prop12*ln(prop12))+ ///
(prop13*ln(prop13))+ ///
(prop14*ln(prop14))+ ///
(prop15*ln(prop15))+ ///
(prop16*ln(prop16))+ ///
(prop17*ln(prop17))+ ///
(prop18*ln(prop18))+ ///
(prop19*ln(prop19))+ ///
(prop20*ln(prop20))+ ///
(prop21*ln(prop21))+ ///
(prop23*ln(prop23))))

* We calculate the normalized shannon's H

gen normshannonsh = (shannonsh/ln(21))

save "shannon parlamento.dta"


** We merge the two files

use "shannon corte.dta"

merge 1:1 unit using "shannon parlamento.dta"

save "shannon corte e parlamento def.dta"


*** In order to obtain the graph of Figure 5. AgendasÕ Entropy of Parliament and Court, per years (1983-2013) (normalized shannon's H): 

label variable unit `"Year"'
label variable normshannonsh_court `"Norm. Shannon's H Court"' 
label variable normshannonsh `"Norm. Shannon's H Parliament"'

twoway (connected normshannonsh unit, xtitle("Year") xlabel(1983(1)2013) mcolor(black) msize(medium) msymbol(Oh) lpattern(solid) mcolor(gray) lcolor(gray)) (connected normshannonsh_court unit, xtitle("Year") xlabel(1983(1)2013) mcolor(black) msize(medium) msymbol(circle) lpattern(solid) mcolor(gray) lcolor(gray))

*** In order to calculate the statistics (mean) of the two indexes: 

summarize  normshannonsh_court if unit < 1994
summarize  normshannonsh_court if unit >= 1994

summarize normshannonsh if unit < 1994
summarize normshannonsh if unit >= 1994
