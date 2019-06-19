*****************************
* DOES PLANNING REFULATION PROTECT INDEPENDENT RETAILERS?
* Do file to test for alternative thresholds used to define small stores and big chains
* Created by Raffaella Sadun (rsadun@hbs.edu)
*****************************

clear
clear matrix
set mem 800m
cd "T:\LSE\Raffaella_Sadun\_Papers Replication\Retail\data"

***********

u  "chains_sept12", replace
bys ruref year: egen c_max=max(count_reg)
gen check=.
replace check=1 if indep==1
replace check=2 if switch==1
replace check=3 if indep==0 & switch==0
gen very_large=emp_lu>1000 if emp_lu!=.
keep if check==3

**** Build alternative types definition
* Firms
gen firm1=. 
replace firm1=1 if a<=10000
replace firm1=2 if a>10000

bys ruref: egen u=max(emp_lu)
gen firm2=. 
replace firm2=1 if u<=150
replace firm2=2 if u>150

gen firm3=. 
replace firm3=1 if a<=10000 | u<=150
replace firm3=2 if a>10000 & u>150

* Stores
gen store1=.
replace store1=1 if emp_lu<28
replace store1=2 if emp_lu>=28

gen store2=.
replace store2=1 if emp_lu<25
replace store2=2 if emp_lu>=25

gen store3=.
replace store3=1 if emp_lu<30
replace store3=2 if emp_lu>=30

gen store4=.
replace store4=1 if emp_lu<35
replace store4=2 if emp_lu>=35

drop type*

foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
gen type`var'`y'=.
replace type`var'`y'=1 if firm`var'==1 & store`y'==1
replace type`var'`y'=2 if firm`var'==1 & store`y'==2
replace type`var'`y'=3 if firm`var'==2 & store`y'==1
replace type`var'`y'=4 if firm`var'==2 & store`y'==2
tab type`var'`y', ge(tt_`var'`y')
}
}
so luref year
save alternative_thresholds, replace
stop

foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
foreach g in 1 2 3 4 {
cap drop agg_shop_`var'`y'`g'
cap drop emp`var'`y'`g'0 
cap drop agg_emp_`var'`y'`g'
bys la_code year: egen agg_shop_`var'`y'`g'=sum(tt_`var'`y'`g')
gen emp`var'`y'`g'0 = emp_lu if tt_`var'`y'`g'==1
bys la_code year: egen agg_emp_`var'`y'`g'=sum(emp`var'`y'`g'0)
cap drop emp`var'`y'`g'0 
}
}
}

* LA wide stats
bys la_code year: egen m_very_large=max(very_large)
so la_code year
drop if la_code==la_code[_n-1]& year==year[_n-1] 
keep la_code year agg_*   m_very*
foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
foreach g in 1 2 3 4 {
so la_code year
bys la_code: gen delta_emp_`var'`y'`g'=ln(agg_emp_`var'`y'`g')-ln(agg_emp_`var'`y'`g'[_n-1])
}
}
}

so la_code year 
save  "datachains_sept12_robustness", replace

u ret_home_pop_basic_entry, replace
merge 1:m la_code year using datachains_sept12_robustness
keep if _m==3 
drop _m
cap drop ln_pop
ge ln_pop=ln(pop_y)
ta year, ge(yy)
drop if m_very==1
drop if delta_emp_113==.
sa ret_home_pop_chains_robustness, replace

u ret_home_pop_chains_robustness, replace
cap estimates drop *
foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
foreach g in 3 4 {
* OLS
eststo: xi: reg delta_emp_`var'`y'`g'  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* IV
* eststo: xi: ivreg2 delta_emp_`var'`y'`g'  (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  
}
}
}
esttab  using ref2_robustness.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_lag2  ) nogap

***** check differences in indep density
u alternative_thresholds, replace
keep luref year firm* store* type* emp_lu la_code 
so luref year
save luref_type_alt, replace

u luref_type_alt, replace
so la_code
merge m:1 la_code using la_code_analysis
keep if _m==3
drop _m
collapse (max) type*, by(luref la_co)

foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
gen smallstore`var'`y'=type`var'`y'==3
replace smallstore`var'`y'=. if type`var'`y'<3
}
}
so luref
merge 1:1 luref using density_postcode
keep if _m==3
ge share_indep=msum_indep/msum_all

cap estimates drop *
foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
eststo: areg msum_all smallstore`var'`y', abs(la_co) cluster(la_co)
eststo: areg msum_chains smallstore`var'`y', abs(la_co) cluster(la_co)
eststo: areg msum_indep smallstore`var'`y', abs(la_co) cluster(la_co)
}
}
esttab  using ref3_density_alt.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(smallstore*) nogap

*** Just indep
cap estimates drop *
foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
eststo: areg msum_indep smallstore`var'`y', abs(la_co) cluster(la_co)
}
}
esttab  using ref3_density_alt_indep.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(smallstore*) nogap

