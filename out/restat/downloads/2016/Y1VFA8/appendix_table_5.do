clear
capture log close
set more off
set mem 500m


**************** Table A5 Column 1 with robust SEs ***************

use data_pt_pop_1891, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1861cotshr=p1861*shr_cot
gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot


****

encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year


************ Regressions ***************

xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr _I*, fe vce(robust)
est store FE1

outreg2 [FE1] using results_appendix_table_5_column_1, tex replace see label  drop(_I*)



**************** Table A5 Column 1 with Spatial SEs ***************
clear

use data_pt_pop_1891, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var

gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot



***** Merge in lat and lon data
sort loc
merge loc using data_city_lat_lon_data
tab _merge
keep if _merge==3
drop _merge


***************
*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.
xi i.year i.loc
gen const=1


************ Regressions ***************

ols_spatial_HAC gr_pop p1871cotshr p1881cotshr p1891cotshr _Iyear_1861 _Iyear_1871 _Iyear_1881 _Iyear_1891 _Iloc_2 _Iloc_3 _Iloc_4 _Iloc_5 _Iloc_6 _Iloc_7 _Iloc_8 _Iloc_9 _Iloc_10 _Iloc_11 _Iloc_12 _Iloc_13 _Iloc_14 _Iloc_15 _Iloc_16 _Iloc_17 _Iloc_18 _Iloc_19 _Iloc_20 _Iloc_21 _Iloc_22 _Iloc_23 _Iloc_24 _Iloc_25 _Iloc_26 _Iloc_27 _Iloc_28 _Iloc_29 _Iloc_30 _Iloc_31 _Iloc_32 _Iloc_33 _Iloc_34 _Iloc_35 _Iloc_36 _Iloc_37 _Iloc_38 _Iloc_39 _Iloc_40 _Iloc_41 _Iloc_42 _Iloc_43 _Iloc_44 _Iloc_45 _Iloc_46 const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store FE0

outreg2 [FE0] using results_appendix_table_5_column_1_spatial, tex replace see label  drop(_I*)




******************** Table A5 Column 2 with robust SEs *********************
clear

use data_pt_pop_1901, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891
gen p1901=0
replace p1901=1 if year==1901

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot


*** 
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year


************ Regressions ***************

xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr _I*, fe vce(robust)
est store REG


outreg2 [REG] using results_appendix_table_5_column_2, tex replace see label  drop(_I*)



**************** Table A5 Column 2 with Spatial SEs
clear

use data_pt_pop_1901, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891
gen p1901=0
replace p1901=1 if year==1901


gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot



***** Merge in lat and lon data
sort loc
merge loc using data_city_lat_lon_data
tab _merge
keep if _merge==3
drop _merge


***************
*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.
xi i.year i.loc
gen const=1

************ Regressions ***************

ols_spatial_HAC gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr  _Iyear_1871 _Iyear_1881 _Iyear_1891 _Iyear_1901 _Iloc_2 _Iloc_3 _Iloc_4 _Iloc_5 _Iloc_6 _Iloc_7 _Iloc_8 _Iloc_9 _Iloc_10 _Iloc_11 _Iloc_12 _Iloc_13 _Iloc_14 _Iloc_15 _Iloc_16 _Iloc_17 _Iloc_18 _Iloc_19 _Iloc_20 _Iloc_21 _Iloc_22 _Iloc_23 _Iloc_24 _Iloc_25 _Iloc_26 _Iloc_27 _Iloc_28 _Iloc_29 _Iloc_30 _Iloc_31 _Iloc_32 _Iloc_33 _Iloc_34 _Iloc_35 _Iloc_36 _Iloc_37 _Iloc_38 _Iloc_39 _Iloc_40 _Iloc_41 _Iloc_42 _Iloc_43 _Iloc_44 _Iloc_45 _Iloc_46 _Iloc_47 _Iloc_48 _Iloc_49 _Iloc_50 _Iloc_51 _Iloc_52 _Iloc_53 _Iloc_54 _Iloc_55 const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store FE0

outreg2 [FE0] using results_appendix_table_5_column_2_spatial, tex replace see label  drop(_I*)




******************** Table A5 Column 3 with robust SEs **********************
clear

use data_pt_pop_1891, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var

gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1861cotshr=p1861*shr_cot
gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot

* Limit to textile cities only
gen shr_tex = shr_wool + shr_other_tex
gen tex=0
replace tex=1 if shr_tex>.1
replace tex=1 if shr_cot>.1
keep if tex==1



*** 
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

************ Regressions ***************

xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr _I*, fe vce(robust)
est store FE1

outreg2 [FE1] using results_appendix_table_5_column_3, tex replace see label  drop(_I*)



**************** Table A5 Column 3 with spatial SEs **********************
clear

use data_pt_pop_1891, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var

gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot

* Limit to textile cities only
gen shr_tex = shr_wool + shr_other_tex
gen tex=0
replace tex=1 if shr_tex>.1
replace tex=1 if shr_cot>.1
keep if tex==1



***** Merge in lat and lon data
sort loc
merge loc using data_city_lat_lon_data
tab _merge
keep if _merge==3
drop _merge



***************
*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.
xi i.year i.loc
gen const=1


************ Regressions ***************

ols_spatial_HAC gr_pop p1871cotshr p1881cotshr p1891cotshr _Iyear_1861 _Iyear_1871 _Iyear_1881 _Iyear_1891 _Iloc_2 _Iloc_3 _Iloc_4 _Iloc_5 _Iloc_6 _Iloc_7 _Iloc_8 _Iloc_9 _Iloc_10 _Iloc_11 _Iloc_12 _Iloc_13 _Iloc_14 _Iloc_15 _Iloc_16 _Iloc_17 _Iloc_18 const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store FE0

outreg2 [FE0] using results_appendix_table_5_column_3_spatial, tex replace see label  drop(_I*)




********************* Table A5 Column 4 with robust SEs ***********************
clear

use data_pt_pop_1901, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc

merge loc using data_town_cotton_shr_1851

tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var

gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891
gen p1901=0
replace p1901=1 if year==1901

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot

* Limit to textile cities only
gen shr_tex = shr_wool + shr_other_tex
gen tex=0
replace tex=1 if shr_tex>.1
replace tex=1 if shr_cot>.1
keep if tex==1

*** 
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

************ Regressions ***************

xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr _I*, fe vce(robust)
est store FE1

outreg2 [FE1] using results_appendix_table_5_column_4, tex replace see label  drop(_I*)



************** Table A5 Column 4 with spatial SEs *******************
clear


use data_pt_pop_1901, clear

*** Fix manchester and salford
replace loc="manchester" if loc=="salford"
count
collapse (sum) pop, by(loc year)
count

sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge


** LHS var
gen log_pop=log(pop)

sort loc year
gen gr_pop=log_pop-log_pop[_n-1] if loc==loc[_n-1]


** RHS var
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891
gen p1901=0
replace p1901=1 if year==1901


gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot


* Limit to textile cities only
gen shr_tex = shr_wool + shr_other_tex
gen tex=0
replace tex=1 if shr_tex>.1
replace tex=1 if shr_cot>.1
keep if tex==1


***** Merge in lat and lon data
sort loc
merge loc using data_city_lat_lon_data
tab _merge
keep if _merge==3
drop _merge



***************
*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.
xi i.year i.loc
gen const=1


************ Regressions ***************


ols_spatial_HAC gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr  _Iyear_1871 _Iyear_1881 _Iyear_1891 _Iyear_1901 _Iloc_2 _Iloc_3 _Iloc_4 _Iloc_5 _Iloc_6 _Iloc_7 _Iloc_8 _Iloc_9 _Iloc_10 _Iloc_11 _Iloc_12 _Iloc_13 _Iloc_14 _Iloc_15 _Iloc_16 _Iloc_17 _Iloc_18 const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(90) lagcutoff(0) star
est store FE0

outreg2 [FE0] using results_appendix_table_5_column_4_spatial, tex replace see label  drop(_I*)







