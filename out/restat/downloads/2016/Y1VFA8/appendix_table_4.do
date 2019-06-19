clear
capture log close
set more off
set mem 500m
set seed 18965765
set matsize 5000



****

use data_town_occupation_data_1851_1871, clear



*** Collapse into group_2 categories
collapse (sum) pop, by(loc group_2 group_2_name year)


** Merge in town cotton shares
sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge


** keep 1861 and 1871
keep if year==1861

**** Confine to analysis cities
sort loc
merge loc using data_analysis_cities_list
tab _merge
keep if _merge==3
drop _merge


********** Generate combined categories *********

*** Textile categories
replace group_2_name="textiles" if group_2==1614
replace group_2_name="textiles" if group_2==1607
replace group_2_name="textiles" if group_2==1605
replace group_2_name="textiles" if group_2==1310
replace group_2_name="textiles" if group_2==1302

** Transport
replace group_2_name="transport" if group_2==801
replace group_2_name="transport" if group_2==802
replace group_2_name="transport" if group_2==809
replace group_2_name="transport" if group_2==811

** Food, drink, tobacco
replace group_2_name="food_etc" if group_2==1201 
replace group_2_name="food_etc" if group_2==1404
replace group_2_name="food_etc" if group_2==1410


** Chemicals
replace group_2_name="chemicals_oils" if group_2==310 
replace group_2_name="chemicals_oils" if group_2==1206

** Drop utilities
drop if group_2==1906

*** Collapse to combined categories
collapse (sum) pop, by(year group_2_name loc)

*** Generate shares by industry category
bysort loc: egen totpop=sum(pop)
gen pop_shr=pop/totpop
keep group_2_name loc pop_shr

*** Number locations
preserve
keep loc
duplicates drop
sort loc
gen loc_no=_n
sort loc
save temp_loc_no, replace
restore

sort loc
merge loc using temp_loc_no
drop _merge
drop loc
rename loc_no loc

** Prepare data to generate correlations
reshape wide pop_shr, i(group_2_name) j(loc)

** Prepare empty database to fill
preserve
clear
gen loc1=""
gen loc2=""
gen corr1=.
save temp_emp_corr, replace
restore



********** Generate correlations for each pair of towns *****

forval i=1/43 {
forval j=`i'/44 {

preserve
corr pop_shr`i' pop_shr`j'

matrix A=r(rho)
clear
svmat A, names(corr)
gen loc1="`i'"
gen loc2="`j'"
append using temp_emp_corr
save temp_emp_corr, replace

restore
}
}

*** Prepare location names to merge back in
use temp_loc_no, clear
tostring loc_no, replace
sort loc_no
save temp_loc_no, replace


**** Load the employment correlations database

use temp_emp_corr, clear

** Drop diagonal observations
drop if loc1==loc2

** Merge location names back in
rename loc1 loc_no
sort loc_no
merge loc_no using temp_loc_no
drop _merge
drop loc_no
rename loc loc1

rename loc2 loc_no
sort loc_no
merge loc_no using temp_loc_no
drop _merge
drop loc_no
rename loc loc2


** Merge in town cotton measures for location 1
rename loc1 loc
sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge
rename loc loc1

gen cotton10=0
replace cotton10=1 if shr_cot>.1
gen tex_shr=shr_wool+shr_other_tex+shr_cot
gen tex10=0
replace tex10=1 if tex_shr>.1
replace tex10=0 if cotton10==1
rename cotton10 cotton1
rename tex10 tex1
keep loc1 loc2 corr1 cotton1 tex1

** Merge in town cotton measures for location 2
rename loc2 loc
sort loc
merge loc using data_town_cotton_shr_1851
tab _merge
keep if _merge==3
drop _merge
rename loc loc2

gen cotton10=0
replace cotton10=1 if shr_cot>.1
gen tex_shr=shr_wool+shr_other_tex+shr_cot
gen tex10=0
replace tex10=1 if tex_shr>.1
replace tex10=0 if cotton10==1
rename cotton10 cotton2
rename tex10 tex2
keep loc1 loc2 corr1 cotton1 tex1 cotton2 tex2



********* Identify town types
gen type=""
replace type="cotton_pair" if cotton1==1 & cotton2==1
replace type="othertex_pair" if tex1==1 & tex2==1
replace type="cot_tex_pair" if tex1==1 & cotton2==1
replace type="cot_tex_pair" if tex2==1 & cotton1==1
replace type="cot_other_pair" if tex1==0 & cotton1==0 & cotton2==1
replace type="cot_other_pair" if tex2==0 & cotton2==0 & cotton1==1

*** Summarize results
sutex corr1 if type=="cotton_pair", minmax file(results_appendix_table_4_cotton_pairs) replace labels
sutex corr1 if type=="othertex_pair", minmax file(results_appendix_table_4_othertex_pair) replace labels
sutex corr1 if type=="cot_tex_pair", minmax file(results_appendix_table_4_cot_tex_pair) replace labels
sutex corr1 if type=="cot_other_pair", minmax file(results_appendix_table_4_cot_other_pair) replace labels


****
