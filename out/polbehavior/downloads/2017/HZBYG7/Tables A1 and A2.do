*Use Vars.dta

set more off

**********************************************************************************
***Table A1: Incognizance Measures by Nation**************************************
**********************************************************************************

***Did Not Place Self on Scale (Percent)
bys B1003: sum percent_no_placed_self_LR

***Did Not Place At Least Two Parties on Scale (Percent)
bys B1003: sum percent_no_placed_min2

*****************************************************************************
***Table A2: Incognizance Measures by Institution****************************
*****************************************************************************

***Did Not Place Self on Scale (Percent)
sum percent_no_placed_self_LR if presidential ==0
sum percent_no_placed_self_LR if presidential ==1

sum percent_no_placed_self_LR if state_leg ==0
sum percent_no_placed_self_LR if state_leg ==1

sum percent_no_placed_self_LR if state_exec ==0
sum percent_no_placed_self_LR if state_exec ==1

sum percent_no_placed_self_LR if newdemo ==0
sum percent_no_placed_self_LR if newdemo ==1

sum percent_no_placed_self_LR if newsys ==0
sum percent_no_placed_self_LR if newsys ==1

sum percent_no_placed_self_LR if fewparties ==0
sum percent_no_placed_self_LR if fewparties ==1

***Did Not Place At Least Two Parties on Scale (Percent)
sum percent_no_placed_min2 if presidential ==0
sum percent_no_placed_min2 if presidential ==1

sum percent_no_placed_min2 if state_leg ==0
sum percent_no_placed_min2 if state_leg ==1

sum percent_no_placed_min2 if state_exec ==0
sum percent_no_placed_min2 if state_exec ==1

sum percent_no_placed_min2 if newdemo ==0
sum percent_no_placed_min2 if newdemo ==1

sum percent_no_placed_min2 if newsys ==0
sum percent_no_placed_min2 if newsys ==1

sum percent_no_placed_min2 if fewparties ==0
sum percent_no_placed_min2 if fewparties ==1

