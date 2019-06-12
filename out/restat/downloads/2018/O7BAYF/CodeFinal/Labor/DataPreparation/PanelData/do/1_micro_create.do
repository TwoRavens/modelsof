***************************************************************************
*******This file creates aggregates for all survey years at the state level
***************************************************************************


***************************************************************
***1960 CPS decenial census
***************************************************************

use "$data/ipums_1960.dta", clear


***drop if no week worked
drop if wkswork2==0

***generate hours worked (midpoint of class)
gen hours=7.5*(hrswork2==1) + 22*(hrswork2==2) + 32*(hrswork2==3) + 37*(hrswork2==4) ///
+ 40*(hrswork2==5) + 44.5*(hrswork2==6) ///
+ 54*(hrswork2==7) + 70*(hrswork2==8) 

***generate weeks worked (midpoint of class)
gen weeks=6.5*(wkswork2==1) + 20*(wkswork2==2) + 33*(wkswork2==3) + 43.5*(wkswork2==4) ///
+ 48.5*(wkswork2==5) + 51*(wkswork2==6) 

*generate pdeflator=4.75
*REPLACE WITH OP DEFLATOR
gen pdeflator=5.725

***drop zero and missing wage income
drop if incwage==0 | incwage==999999

***As in Borjas, replace top coded by 1.5*top code
replace incwage=25000*1.5 if incwage==25000
replace incbusfm=25000*1.5 if incbusfm==25000

***generate total income earned
gen incearn=incwage+incbusfm

**************************************************************
****run the code which works for all years, including collapse
do "$do/1a_micro_create_common.do"
**************************************************************

***aggregate wages
***save final survey year aggregate wages
***note that mean earnings are weighted by hours worked
***collapse by education and experience code like Borjas 
preserve
***wage selection
***select full time males
drop if weeks<40
drop if hours<35
drop if sex==2

collapse (mean) lweekly weekly educ4 experience2 [aw=weight], by(stateicp ltypes)
gen survey=1960
sort survey stateicp ltypes educ4 experience2
save "$data/agg_wages_1960.dta", replace

restore

***aggregate labor supply
***(weights include hours worked), just not collapsed by immigrant definition here but
***state level instead
***leave all in, females, males, part time
preserve
collapse (mean) educ4 experience2 (sum) sizew=weight [aw=weight], by(stateicp ltypes)
gen survey=1960
sort survey stateicp ltypes educ4 experience2
save "$data/agg_supply_1960.dta", replace
restore



***************************************************************
***1970 CPS decenial census
***************************************************************

use "$data/ipums_1970.dta", clear


***drop if no week worked
drop if wkswork2==0

***generate hours worked (midpoint of class)
gen hours=7.5*(hrswork2==1) + 22*(hrswork2==2) + 32*(hrswork2==3) 	+ 37*(hrswork2==4) ///
+ 40*(hrswork2==5) + 44.5*(hrswork2==6) ///
+ 54*(hrswork2==7) + 70*(hrswork2==8) ///

***generate weeks worked (midpoint of class)
gen weeks=6.5*(wkswork2==1) + 20*(wkswork2==2) + 33*(wkswork2==3) + 43.5*(wkswork2==4) ///
+ 48.5*(wkswork2==5) + 51*(wkswork2==6) ///

***as Borjas
***generate pdeflator=3.63;
***REPLACE WITH OP DEFLATOR;
gen pdeflator=4.54

***drop zero and missing wage income
drop if incwage==0 | incwage==999999

***As in Borjas, replace top coded by 1.5*top code
replace incwage=50000*1.5 if incwage==50000
replace incbus=50000*1.5 if incbus==50000
replace incfarm=50000*1.5 if incfarm==50000

***generate total income earned
gen incearn=incwage+incbus+incfarm

			
**************************************************************
****run the code which works for all years, including collapse
do "$do/1a_micro_create_common.do"
**************************************************************

***aggregate wages
***save final survey year aggregate wages
***note that mean earnings are weighted by hours worked
***collapse by education and experience code like Borjas 
preserve
***wage selection
***select full time males
drop if weeks<40
drop if hours<35
drop if sex==2

collapse (mean) lweekly weekly educ4 experience2 [aw=weight], by(stateicp ltypes)
gen survey=1970
sort survey stateicp educ4 experience2
save "$data/agg_wages_1970.dta", replace

restore


***aggregate labor supply
***(weights include hours worked), just not collapsed by immigrant definition here but
***state level instead
***leave all in, females, males, part time
preserve
collapse (mean) educ4 experience2 (sum) sizew=weight [aw=weight], by(stateicp ltypes)
gen survey=1970
sort survey stateicp educ4 experience2
save "$data/agg_supply_1970.dta", replace
restore



			
***************************************************************
***1980 CPS decenial census
***************************************************************

use "$data/ipums_1980.dta", clear


***drop if no week worked
drop if wkswork1==0

***as Borjas
***generate pdeflator=1.85
***REPLACE WITH OP DEFLATOR
gen pdeflator=2.314

***drop zero and missing wage income
drop if incwage==0 | incwage==999999

***As in Borjas, replace top coded by 1.5*top code
replace incwage=75000*1.5 if incwage==75000
replace incbus=75000*1.5 if incbus==75000
replace incfarm=75000*1.5 if incfarm==75000

***generate total income earned
gen incearn=incwage+incbus+incfarm

***weeks worked now available
gen weeks=wkswork1

***hours worked now available in the CPS decenial census
gen hours=uhrswork

**************************************************************
****run the code which works for all years, including collapse
do "$do/1a_micro_create_common.do"
**************************************************************

***aggregate wages
***save final survey year aggregate wages
***note that mean earnings are weighted by hours worked
***collapse by education and experience code like Borjas 
preserve
***wage selection
***select full time males
drop if weeks<40
drop if hours<35
drop if sex==2

collapse (mean) lweekly weekly educ4 experience2  [aw=weight], by(stateicp ltypes)
gen survey=1980
sort survey stateicp educ4 experience2
save "$data/agg_wages_1980.dta", replace

restore


***aggregate labor supply
***(weights include hours worked), just not collapsed by immigrant definition here but
***state level instead
***leave all in, females, males, part time
preserve
collapse (mean) educ4 experience2 (sum) sizew=weight [aw=weight], by(stateicp ltypes)
gen survey=1980
sort survey stateicp educ4 experience2
save "$data/agg_supply_1980.dta", replace
restore



***************************************************************
***1990 CPS decenial census
***************************************************************


use "$data/ipums_1990.dta", clear


***drop if no week worked
drop if wkswork1==0

***as Borjas
***generate pdeflator=1.22
***REPLACE WITH OP DEFLATOR
gen pdeflator=1.344

***drop zero and missing wage income
drop if incwage==0 | incwage==999999

***generate total income earned
gen incearn=incwage+incbus+incfarm

***weeks worked now available
gen weeks=wkswork1

***hours worked now available
gen hours=uhrswork


**************************************************************
****run the code which works for all years, including collapse
do "$do/1a_micro_create_common.do"
**************************************************************

***aggregate wages
***save final survey year aggregate wages
***note that mean earnings are weighted by hours worked
***collapse by education and experience code like Borjas 
preserve
***wage selection
***select full time males
drop if weeks<40
drop if hours<35
drop if sex==2

collapse (mean) lweekly weekly educ4 experience2 [aw=weight], by(stateicp ltypes)
gen survey=1990
sort survey stateicp educ4 experience2
save "$data/agg_wages_1990.dta", replace

restore


***aggregate labor supply
***(weights include hours worked), just not collapsed by immigrant definition here but
***state level instead
***leave all in, females, males, part time
preserve
collapse (mean) educ4 experience2 (sum) sizew=weight [aw=weight], by(stateicp ltypes)
gen survey=1990
sort survey stateicp educ4 experience2
save "$data/agg_supply_1990.dta", replace
restore



***************************************************************
***2000 CPS decenial census
***************************************************************

use "$data/ipums_2000.dta", clear


***drop if no week worked
drop if wkswork1==0

***as Borjas
***THIS IS ALSO THE BASE YEAR WITH OP DEFLATOR;
generate pdeflator=1

***drop zero and missing wage income
drop if incwage==0 | incwage==999999

***generate total income earned
gen incearn=incwage+incbus+incfarm

***weeks worked now available
generate weeks=wkswork1

***hours worked now available
gen hours=uhrswork


**************************************************************
****run the code which works for all years, including collapse
do "$do/1a_micro_create_common.do"
**************************************************************

***aggregate wages
***save final survey year aggregate wages
***note that mean earnings are weighted by hours worked
***collapse by education and experience code like Borjas 
preserve
***wage selection
***select full time males
drop if weeks<40
drop if hours<35
drop if sex==2

collapse (mean) lweekly weekly educ4 experience2 [aw=weight], by(stateicp ltypes)
gen survey=2000
sort survey stateicp educ4 experience2
save "$data/agg_wages_2000.dta", replace

restore


***aggregate labor supply
***(weights include hours worked), just not collapsed by immigrant definition here but
***state level instead
***leave all in, females, males, part time
preserve
collapse (mean) educ4 experience2 (sum) sizew=weight [aw=weight], by(stateicp ltypes)
gen survey=2000
sort survey stateicp educ4 experience2
save "$data/agg_supply_2000.dta", replace
restore




***************************************************************
***2006 ACS 
***************************************************************


use "$data/ipums_2006.dta", clear


***drop if no week worked
drop if wkswork1==0

***as Borjas
***generate pdeflator=0.85
***REPLACE WITH OP DEFLATOR
gen pdeflator=0.853

***drop zero and missing wage income
drop if incwage==0 | incwage==999999

***generate total income earned
gen incearn=incwage+incbus+incfarm

***weeks worked now available
generate weeks=wkswork1

***hours worked now available
generate hours=uhrswork


**************************************************************
****run the code which works for all years, including collapse
do "$do/1a_micro_create_common.do"
**************************************************************

***aggregate wages
***save final survey year aggregate wages
***note that mean earnings are weighted by hours worked
***collapse by education and experience code like Borjas 
preserve
***wage selection
***select full time males
drop if weeks<40
drop if hours<35
drop if sex==2

collapse (mean) lweekly weekly educ4 experience2 [aw=weight], by(stateicp ltypes)
gen survey=2006
sort survey stateicp educ4 experience2
save "$data/agg_wages_2006.dta", replace

restore


***aggregate labor supply
***(weights include hours worked), just not collapsed by immigrant definition here but
***state level instead
***leave all in, females, males, part time
preserve
collapse (mean) educ4 experience2 (sum) sizew=weight [aw=weight], by(stateicp ltypes)
gen survey=2006
sort survey stateicp educ4 experience2
save "$data/agg_supply_2006.dta", replace
restore



***************************************************************
***create time series
***************************************************************

***wages
***start year
foreach year of glo yearsf {
use "$data/agg_wages_`year'.dta", clear

}


***all years but first
foreach year of glo yearsbf {

	append using "$data/agg_wages_`year'.dta"
			 
}

save "$data/ts_wages.dta", replace



***supply
***start year
foreach year of glo yearsf {
use "$data/agg_supply_`year'.dta", clear

}


***all years but first
foreach year of glo yearsbf {

	append using "$data/agg_supply_`year'.dta"
			 
}

save "$data/ts_supply.dta", replace




