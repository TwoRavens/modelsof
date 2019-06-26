clear all
set more off
set mem 500m
set mat 800


use "K-adic Nonaggression Main Data", clear

* Generate Data used for Figure 1
capture drop post_1900
gen post_1900 = year if year>1900 & form==1
bysort post_1900: sum form


* Generate Results for Table I
ttest prop_rival_end if _st==1, by(form)

* Generate Results for Table II, Column 1
tab nummem if split~=.

* Generate Results for Table II, Column 2
sum prop_rival_end if nummem==2 & split~=.
sum prop_rival_end if nummem==3 & split~=.
sum prop_rival_end if nummem==4 & split~=.
sum prop_rival_end if nummem==5 & split~=.
sum prop_rival_end if nummem>5 & nummem~=. & split~=.

* Generate Results for Table II, Column 3
tab nummem if form==1 & split~=.

* Generate Results for Table II, Column 4
* Note: Using the output from the following command, Multiply the figures in the "Number of Members" column by the figures in the "Freq." column
tab nummem if form==1 & split~=.

* Generate Results for Table II, Column 5
tab nummem if time_diff>=0 & time_diff~=. & form==1

* Generate Results for Table III
stcox prop_rival_end
stcox prop_rival_end nummem prop_mid 
stcox prop_rival_end nummem prop_mid Russia China
stcox prop_rival_end nummem prop_mid Russia China total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s

* Test the proportional hazard assumption (Note in Table III)
capture drop sch* 
capture drop sca*
capture drop mgresid
stcox prop_rival_end prop_mid nummem total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s Russia China, nolog efron nohr  sch(sch*) sca(sca*) mg(mgresid)
stphtest
stphtest, detail


* Most Frequently Appearing countries
preserve
keep if form==1
keep mem*
stack mem1-mem31, into(ccode) clear
drop if ccode==.
tab ccode
restore
