clear
capture log close
set more off
set mem 500m


****

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
gen cotton10=0
replace cotton10=1 if shr_cot>.1


gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891

gen p1861cot10=p1861*cotton10
gen p1871cot10=p1871*cotton10
gen p1881cot10=p1881*cotton10
gen p1891cot10=p1891*cotton10

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot

gen shr_otex=shr_wool +shr_other_tex
gen other_tex10=0
replace other_tex10=1 if shr_otex>.1

gen p1861otex10=p1861*other_tex10
gen p1871otex10=p1871*other_tex10
gen p1881otex10=p1881*other_tex10
gen p1891otex10=p1891*other_tex10

gen p1871otexshr=p1871*shr_otex
gen p1881otexshr=p1881*shr_otex
gen p1891otexshr=p1891*shr_otex


*** Generate identifier for cities in the Northwest or Yorkshire
gen lanc_york=0
replace lanc_york=1 if loc=="blackburn"
replace lanc_york=1 if loc=="bolton"
replace lanc_york=1 if loc=="bradford"
replace lanc_york=1 if loc=="burnley"
replace lanc_york=1 if loc=="bury"
replace lanc_york=1 if loc=="halifax"
replace lanc_york=1 if loc=="huddersfield"
replace lanc_york=1 if loc=="hull"
replace lanc_york=1 if loc=="leeds"
replace lanc_york=1 if loc=="liverpool"
replace lanc_york=1 if loc=="manchester"
replace lanc_york=1 if loc=="oldham"
replace lanc_york=1 if loc=="preston"
replace lanc_york=1 if loc=="rochdale"
replace lanc_york=1 if loc=="sheffield"
replace lanc_york=1 if loc=="stockport"
replace lanc_york=1 if loc=="warrington"
replace lanc_york=1 if loc=="wigan"
replace lanc_york=1 if loc=="york"

gen man_lon=0
replace man_lon=1 if loc=="manchester"
replace man_lon=1 if loc=="london"

*******************************************************************************
************ Regressions ***************


*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year


*** Combined specification
xtreg gr_pop p1871cot10 p1881cot10 p1891cot10 p1871otex10 p1881otex10 p1891otex10 _I*, fe vce(robust)
est store ROB1

outreg2 [ROB1] using results_appendix_table_6_column_1, tex replace see label  drop(_I*)


*** Combined specification - continuous
xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr p1871otexshr p1881otexshr p1891otexshr _I*, fe vce(robust)
est store ROB2

outreg2 [ROB2] using results_appendix_table_6_column_3, tex replace see label  drop(_I*)


*** Lancashire, Cheshire and Yorkshire only
xtreg gr_pop p1871cot10 p1881cot10 p1891cot10 _I* if lanc_york==1, fe vce(robust)
est store ROB3

outreg2 [ROB3] using results_appendix_table_7_column_1, tex replace see label  drop(_I*)


*** Dropping Manchester
xtreg gr_pop p1871cot10 p1881cot10 p1891cot10 _I* if man_lon==0, fe vce(robust)
est store ROB4

outreg2 [ROB4] using results_appendix_table_7_column_3, tex replace see label  drop(_I*)


************ Now with spatial SEs ***************
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
gen cotton10=0
replace cotton10=1 if shr_cot>.1

gen p1861=0
replace p1861=1 if year==1861
gen p1871=0
replace p1871=1 if year==1871
gen p1881=0
replace p1881=1 if year==1881
gen p1891=0
replace p1891=1 if year==1891


gen p1871cot10=p1871*cotton10
gen p1881cot10=p1881*cotton10
gen p1891cot10=p1891*cotton10

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot

gen shr_otex=shr_wool +shr_other_tex
gen other_tex10=0
replace other_tex10=1 if shr_otex>.1


gen p1871otex10=p1871*other_tex10
gen p1881otex10=p1881*other_tex10
gen p1891otex10=p1891*other_tex10

gen p1871otexshr=p1871*shr_otex
gen p1881otexshr=p1881*shr_otex
gen p1891otexshr=p1891*shr_otex


*** Generate identifier for cities in the Northwest or Yorkshire
gen lanc_york=0
replace lanc_york=1 if loc=="blackburn"
replace lanc_york=1 if loc=="bolton"
replace lanc_york=1 if loc=="bradford"
replace lanc_york=1 if loc=="burnley"
replace lanc_york=1 if loc=="bury"
replace lanc_york=1 if loc=="halifax"
replace lanc_york=1 if loc=="huddersfield"
replace lanc_york=1 if loc=="hull"
replace lanc_york=1 if loc=="leeds"
replace lanc_york=1 if loc=="liverpool"
replace lanc_york=1 if loc=="manchester"
replace lanc_york=1 if loc=="oldham"
replace lanc_york=1 if loc=="preston"
replace lanc_york=1 if loc=="rochdale"
replace lanc_york=1 if loc=="sheffield"
replace lanc_york=1 if loc=="stockport"
replace lanc_york=1 if loc=="warrington"
replace lanc_york=1 if loc=="wigan"
replace lanc_york=1 if loc=="york"

gen man_lon=0
replace man_lon=1 if loc=="manchester"
replace man_lon=1 if loc=="london"


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


*******************************************************************************
************ Regressions ***************

** Combine 
ols_spatial_HAC gr_pop p1871cot10 p1881cot10 p1891cot10 p1871otex10 p1881otex10 p1891otex10  _Iloc* _Iyear*  const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store RS1
outreg2 [RS1] using results_appendix_table_6_column_1_spatial, tex replace see label  drop(_I*)

** Combined, continuous cotton measure
ols_spatial_HAC gr_pop p1871cotshr p1881cotshr p1891cotshr p1871otexshr p1881otexshr p1891otexshr _Iloc* _Iyear* const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store RS2
outreg2 [RS2] using results_appendix_table_6_column_3_spatial, tex replace see label  drop(_I*)

** Lancashire and Yorkshire only
preserve
keep if lanc_york==1
drop _I*
xi i.year i.loc
ols_spatial_HAC gr_pop p1871cot10 p1881cot10 p1891cot10  _Iloc* _Iy* const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(50) lagcutoff(0) star
est store RS3
outreg2 [RS3] using results_appendix_table_7_column_1_spatial, tex replace see label  drop(_I*)
restore

** Without manchester and london
preserve
drop if man_lon==1
drop _I*
xi i.year i.loc
ols_spatial_HAC gr_pop p1871cot10 p1881cot10 p1891cot10  _Iloc* _Iy* const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store RS3
outreg2 [RS3] using results_appendix_table_7_column_3_spatial, tex replace see label  drop(_I*)
restore




************** Now using data to 1901 ****************
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
gen cotton10=0
replace cotton10=1 if shr_cot>.1

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

gen p1871cot10=p1871*cotton10
gen p1881cot10=p1881*cotton10
gen p1891cot10=p1891*cotton10
gen p1901cot10=p1901*cotton10

gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot

gen shr_otex=shr_wool +shr_other_tex
gen other_tex10=0
replace other_tex10=1 if shr_otex>.1


gen p1871otex10=p1871*other_tex10
gen p1881otex10=p1881*other_tex10
gen p1891otex10=p1891*other_tex10
gen p1901otex10=p1901*other_tex10

gen p1871otexshr=p1871*shr_otex
gen p1881otexshr=p1881*shr_otex
gen p1891otexshr=p1891*shr_otex
gen p1901otexshr=p1901*shr_otex

*** Generate identifier for cities in the Northwest or Yorkshire
gen lanc_york=0
replace lanc_york=1 if loc=="blackburn"
replace lanc_york=1 if loc=="bolton"
replace lanc_york=1 if loc=="bradford"
replace lanc_york=1 if loc=="burnley"
replace lanc_york=1 if loc=="bury"
replace lanc_york=1 if loc=="halifax"
replace lanc_york=1 if loc=="huddersfield"
replace lanc_york=1 if loc=="hull"
replace lanc_york=1 if loc=="leeds"
replace lanc_york=1 if loc=="liverpool"
replace lanc_york=1 if loc=="manchester"
replace lanc_york=1 if loc=="oldham"
replace lanc_york=1 if loc=="preston"
replace lanc_york=1 if loc=="rochdale"
replace lanc_york=1 if loc=="sheffield"
replace lanc_york=1 if loc=="stockport"
replace lanc_york=1 if loc=="warrington"
replace lanc_york=1 if loc=="wigan"
replace lanc_york=1 if loc=="york"

gen man_lon=0
replace man_lon=1 if loc=="manchester"
replace man_lon=1 if loc=="london"


*******************************************************************************
************ Regressions ***************

*** Panel regregssions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.

xi i.year

*** Combined specification
xtreg gr_pop p1871cot10 p1881cot10 p1891cot10 p1901cot10 p1871otex10 p1881otex10 p1891otex10 p1901otex10 _I*, fe vce(robust)
est store ROB1
outreg2 [ROB1] using results_appendix_table_6_column_2, tex replace see label  drop(_I*)


*** Combined specification - continuous
xtreg gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr p1871otexshr p1881otexshr p1891otexshr p1901otexshr _I*, fe vce(robust)
est store ROB2

outreg2 [ROB2] using results_appendix_table_6_column_4, tex replace see label  drop(_I*)


*** Lancashire, Cheshire and Yorkshire only
xtreg gr_pop p1871cot10 p1881cot10 p1891cot10 p1901cot10 _I* if lanc_york==1, fe vce(robust)
est store ROB3

outreg2 [ROB3] using results_appendix_table_7_column_2, tex replace see label  drop(_I*)


*** Dropping Manchester
xtreg gr_pop p1871cot10 p1881cot10 p1891cot10 p1901cot10 _I* if man_lon==0, fe vce(robust)
est store ROB4

outreg2 [ROB4] using results_appendix_table_7_column_4, tex replace see label  drop(_I*)




******************** Now using 1901 data and spatial SEs *************
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
gen cotton10=0
replace cotton10=1 if shr_cot>.1

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

gen p1871cot10=p1871*cotton10
gen p1881cot10=p1881*cotton10
gen p1891cot10=p1891*cotton10
gen p1901cot10=p1901*cotton10


gen p1871cotshr=p1871*shr_cot
gen p1881cotshr=p1881*shr_cot
gen p1891cotshr=p1891*shr_cot
gen p1901cotshr=p1901*shr_cot

gen shr_otex=shr_wool +shr_other_tex
gen other_tex10=0
replace other_tex10=1 if shr_otex>.1


gen p1871otex10=p1871*other_tex10
gen p1881otex10=p1881*other_tex10
gen p1891otex10=p1891*other_tex10
gen p1901otex10=p1901*other_tex10

gen p1871otexshr=p1871*shr_otex
gen p1881otexshr=p1881*shr_otex
gen p1891otexshr=p1891*shr_otex
gen p1901otexshr=p1901*shr_otex

*** Generate identifier for cities in the Northwest or Yorkshire
gen lanc_york=0
replace lanc_york=1 if loc=="blackburn"
replace lanc_york=1 if loc=="bolton"
replace lanc_york=1 if loc=="bradford"
replace lanc_york=1 if loc=="burnley"
replace lanc_york=1 if loc=="bury"
replace lanc_york=1 if loc=="halifax"
replace lanc_york=1 if loc=="huddersfield"
replace lanc_york=1 if loc=="hull"
replace lanc_york=1 if loc=="leeds"
replace lanc_york=1 if loc=="liverpool"
replace lanc_york=1 if loc=="manchester"
replace lanc_york=1 if loc=="oldham"
replace lanc_york=1 if loc=="preston"
replace lanc_york=1 if loc=="rochdale"
replace lanc_york=1 if loc=="sheffield"
replace lanc_york=1 if loc=="stockport"
replace lanc_york=1 if loc=="warrington"
replace lanc_york=1 if loc=="wigan"
replace lanc_york=1 if loc=="york"

gen man_lon=0
replace man_lon=1 if loc=="manchester"
replace man_lon=1 if loc=="london"


***** Merge in lat and lon data
sort loc
merge loc using data_city_lat_lon_data
tab _merge
keep if _merge==3
drop _merge


**** prepare for regressions
encode loc, gen(loc_code)
xtset loc_code year, yearly
drop if gr_pop==.
xi i.year i.loc
gen const=1

*******************************************************************************
************ Regressions ***************

** Combine 
ols_spatial_HAC gr_pop p1871cot10 p1881cot10 p1891cot10 p1901cot10 p1871otex10 p1881otex10 p1891otex10 p1901otex10 _Iloc* _Iyear*  const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store RS1
outreg2 [RS1] using results_appendix_table_6_column_2_spatial, tex replace see label  drop(_I*)

** Combined, continuous cotton measure
ols_spatial_HAC gr_pop p1871cotshr p1881cotshr p1891cotshr p1901cotshr p1871otexshr p1881otexshr p1891otexshr p1901otexshr _Iloc* _Iyear* const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store RS2
outreg2 [RS2] using results_appendix_table_6_column_4_spatial, tex replace see label  drop(_I*)

** Lancashire and Yorkshire only
preserve
keep if lanc_york==1
drop _I*
xi i.year i.loc
ols_spatial_HAC gr_pop p1871cot10 p1881cot10 p1891cot10 p1901cot10 _Iloc* _Iy* const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(50) lagcutoff(0) star
est store RS3
outreg2 [RS3] using results_appendix_table_7_column_2_spatial, tex replace see label  drop(_I*)
restore

** Without manchester
preserve
drop if man_lon==1
drop _I*
xi i.year i.loc
ols_spatial_HAC gr_pop p1871cot10 p1881cot10 p1891cot10 p1901cot10 _Iloc* _Iy* const, lat(lat) lon(lon) timevar(year) panelvar(loc_code) distcutoff(100) lagcutoff(0) star
est store RS3
outreg2 [RS3] using results_appendix_table_7_column_4_spatial, tex replace see label  drop(_I*)
restore






*****
