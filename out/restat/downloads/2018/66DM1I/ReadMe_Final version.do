****Do-file for "Infant Health Care and Long-Term Outcomes"

set matsize 1600
clear
cd "/home1/katrine/AlineKatrineKjell/data/170215"
use "data_individual_level.dta"

*keep individuals bron from 1936-1960
keep if yob>1935 & yob<1961
*drop Oslo and Bergen
drop if fodes==301|fodes==1201
*drop municiaplities outside of mainland Norway (e.g. Svalbard)
drop if fodes>2000
*drop if gender is missing
drop if female<0 | female==.
*drop if mother's id is missing
drop if nmpid==.

************************
*Table 1****************
*Long-term Effects of Access to a Mother and Child Health Care Center on Education and Earnings
************************
*Education
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*(column 3 - no controls)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend, cluster(fodes)
est store AKK2
restore
*(column 4 - all municipalities)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK3
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
*(column 3 - no controls)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend if eduy!=., cluster(fodes)
est store AKK2
restore
*(column 4 - all municipalities)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*Earnings age 31-50, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
*(column 3 - no controls)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend if eduy!=., cluster(fodes)
est store AKK2
restore
*(column 4 - all municipalities)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table 2***************
*Mother-Specific Fixed Effects
************************
*number of chioldren by sam mother
bys nmpid: gen N = [_N]

*Education
preserve
*drop 1-child families
keep if N>=2
drop if open==.
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
iis nmpid
*(column 2 - FE)
xi: quietly xtreg eduy main i.yob i.fodes female border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, fe cluster(nmpid)
est store AKK1
*(column 3 - OLS on FE sample)
xi: quietly reg eduy main i.yob i.fodes female border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
*(column 4 - older siblings)
*Treatment indicator for family
by nmpid: egen main_family=mean(main)
*drop all families where all kids are treated
drop if main_family==1
*create dummy variable indicating whether family is teated
replace main_family=1 if main_family!=0
*drop all treated individuals
drop if main==1
drop main
rename main_family main
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*drop 1-child families
keep if N>=2
drop if open==.
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=.
iis nmpid
*(column 2 - FE)
xi: quietly xtreg pearnallyears main i.yob i.fodes female border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., fe cluster(nmpid)
est store AKK1
*(column 3 - OLS on FE sample)
xi: quietly reg pearnallyears main i.yob i.fodes female border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
*(column 4 - older siblings)
*Treatment indicator for family
by nmpid: egen main_family=mean(main)
*drop all families where all kids are treated
drop if main_family==1
*create dummy variable indicating whether family is teated
replace main_family=1 if main_family!=0
*drop all treated individuals
drop if main==1
drop main
rename main_family main
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings age 31-50, conditional on observing education
preserve
*drop 1-child families
keep if N>=2
drop if open==.
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=.
iis nmpid
*(column 2 - FE)
xi: quietly xtreg pearn3150 main i.yob i.fodes female border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., fe cluster(nmpid)
est store AKK1
*(column 3 - OLS on FE sample)
xi: quietly reg pearn3150 main i.yob i.fodes female border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
*(column 4 - older siblings)
*Treatment indicator for family
by nmpid: egen main_family=mean(main)
*drop all families where all kids are treated
drop if main_family==1
*create dummy variable indicating whether family is teated
replace main_family=1 if main_family!=0
*drop all treated individuals
drop if main==1
drop main
rename main_family main
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table 3****************
*Heterogenous Effects
************************
*GENDER
*Education
preserve
*keep eventually open center 
drop if open==. 
*women
keep if female==1
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*men
keep if female==0
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*women
keep if female==1
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*men
keep if female==0
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings age 31-50, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*women
keep if female==1
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*men
keep if female==0
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*FATHERS' EDUCATION
*Education
preserve
*keep eventually open center 
drop if open==. 
*high school
keep if f_eduy70==1
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*no high school
keep if f_eduy70==0
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*high school
keep if f_eduy70==1
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*no high school
keep if f_eduy70==0
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings age 31-50, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*high school
keep if f_eduy70==1
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*no high school
keep if f_eduy70==0
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*URBAN RURAL
*Education
preserve
*keep eventually open center 
drop if open==. 
*urban
keep if by==1
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*rural
keep if by==0
*prereform mean (column 3)
sum eduy if main==0 & fodes!=.
*(column 4 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*urban
keep if by==1
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*rural
keep if by==0
*prereform mean (column 3)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 4 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings age 31-50, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*urban
keep if by==1
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*rural
keep if by==0
*prereform mean (column 3)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 4 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*INFANT MORTALITY
*Education
preserve
*keep eventually open center 
drop if open==. 
*urban
keep if inf_median==1
*prereform mean (column 1)
sum eduy if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*rural
keep if inf_median==0
*prereform mean (column 3)
sum eduy if main==0 & fodes!=.
*(column 4 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*urban
keep if inf_median==1
*prereform mean (column 1)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*rural
keep if inf_median==0
*prereform mean (column 3)
sum pearnallyears if main==0 & fodes!=. & eduy!=.
*(column 4 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings age 31-50, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*urban
keep if inf_median==1
*prereform mean (column 1)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 2 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
preserve
*keep eventually open center 
drop if open==. 
*rural
keep if inf_median==0
*prereform mean (column 3)
sum pearn3150 if main==0 & fodes!=. & eduy!=.
*(column 4 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table 4****************
*Effect of Access to Mother and Child Health Care Center on Intergenerational Persistence in Educational Attainments Across Generations
************************
preserve
*Men
drop if female==1
*keep eventually open center 
drop if open==. 
*interaction
g main_feduy=main*f_eduyears70
xi: quietly reg eduy feduy main_feduy i.yob i.fodes m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
xi: quietly reg eduy feduy main_feduy i.yob*f_eduyears70 i.fodes*f_eduyears70 i.f_eduyears70*m_eduy70 i.f_eduyears70*miss_m_eduy70 i.f_eduyears70*m_agebirth i.f_eduyears70*miss_m_agebirth i.f_eduyears70*f_agebirth ///
	i.f_eduyears70*miss_f_agebirth i.f_eduyears70*m_married i.f_eduyears70*miss_m_married i.f_eduyears70*border i.f_eduyears70*miss_border i.f_eduyears70*legepop i.f_eduyears70*miss_legepop i.f_eduyears70*stratio6 i.f_eduyears70*miss_stratio i.f_eduyears70*pop i.f_eduyears70*pop_miss, cluster(fodes)
est store AKK2
restore
preserve
*Women
drop if female==0
*keep eventually open center 
drop if open==. 
*interaction
g main_feduy=main*f_eduyears70
xi: quietly reg eduy f_eduyears70 main_feduy i.yob i.fodes m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK3
xi: quietly reg eduy f_eduyears70 main_feduy i.yob*f_eduyears70 i.fodes*f_eduyears70 i.f_eduyears70*m_eduy70 i.f_eduyears70*miss_m_eduy70 i.f_eduyears70*m_agebirth i.f_eduyears70*miss_m_agebirth i.f_eduyears70*f_agebirth ///
	i.f_eduyears70*miss_f_agebirth i.f_eduyears70*m_married i.f_eduyears70*miss_m_married i.f_eduyears70*border i.f_eduyears70*miss_border i.f_eduyears70*legepop i.f_eduyears70*miss_legepop i.f_eduyears70*stratio6 i.f_eduyears70*miss_stratio i.f_eduyears70*pop i.f_eduyears70*pop_miss, cluster(fodes)
est store AKK4
restore
esttab AKK1 AKK2 AKK3 AKK4, keep(f_eduyears70 main_feduy) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)



************************
*Table 5****************
*Long-term Effects of Access to Different Types of Mother and Child Health Care Center on Education and Earnings
************************
*Education
preserve
*keep eventually open center 
drop if open==. 
*(column 1 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
*(column 2 - extra services)
preserve
*keep eventually open center 
drop if open==. 
keep if extracare==1
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
restore
*(column 3 - no extra services)
preserve
*keep eventually open center 
drop if open==. 
keep if extracare==0
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*(column 1 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
*(column 2 - extra services)
preserve
*keep eventually open center 
drop if open==. 
keep if extracare==1
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
restore
*(column 3 - no extra services)
preserve
*keep eventually open center 
drop if open==. 
keep if extracare==0
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*Earnings age 31-50, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*(column 1 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
*(column 2 - extra services)
preserve
*keep eventually open center 
drop if open==. 
keep if extracare==1
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
restore
*(column 3 - no extra services)
preserve
*keep eventually open center 
drop if open==. 
keep if extracare==0
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=. , cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table 6****************
*Short-term Effects of Access to a Mother and Child Health Care Center on Infant Mortality
************************
clear
use "mortality_regression.dta"
*Infant mortality
replace rateall=rateall*1000
*prereform mean (column 1)
sum rateall if main==0 & open_year!=.
*(column 2 - baseline)
reg rateall main i.lnummer i.year if open_year!=., cluster(lnummer)
est store AKK1
*(column 3 - all municipalities)
reg rateall main i.lnummer i.year , cluster(lnummer)
est store AKK2
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Infant mortality from congenital malformations
replace ratecong=ratecong*1000
*prereform mean (column 1)
sum ratecong if main==0 & open_year!=.
*(column 2 - baseline)
reg ratecong main i.lnummer i.year if open_year!=., cluster(lnummer)
est store AKK1
*(column 3 - all municipalities)
reg ratecong main i.lnummer i.year , cluster(lnummer)
est store AKK2
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Infant mortality from pneumonia
replace ratepneu=ratepneu*1000
*prereform mean (column 1)
sum ratepneu if main==0 & open_year!=.
*(column 2 - baseline)
reg ratepneu main i.lnummer i.year if open_year!=., cluster(lnummer)
est store AKK1
*(column 3 - all municipalities)
reg ratepneu main i.lnummer i.year , cluster(lnummer)
est store AKK2
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Infant mortality from diarrhea
replace ratediarr=ratediarr*1000
*prereform mean (column 1)
sum ratediarr if main==0 & open_year!=.
*(column 2 - baseline)
reg ratediarr main i.lnummer i.year if open_year!=., cluster(lnummer)
est store AKK1
*(column 3 - all municipalities)
reg ratediarr main i.lnummer i.year , cluster(lnummer)
est store AKK2
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Infant mortality from pertussis
replace ratewhopp=ratewhopp*1000
*prereform mean (column 1)
sum ratewhopp if main==0 & open_year!=.
*(column 2 - baseline)
reg ratewhopp main i.lnummer i.year if open_year!=., cluster(lnummer)
est store AKK1
*(column 3 - all municipalities)
reg ratewhopp main i.lnummer i.year , cluster(lnummer)
est store AKK2
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Infant mortality from TB
replace ratetb=ratetb*1000
*prereform mean (column 1)
sum ratetb if main==0 & open_year!=.
*(column 2 - baseline)
reg ratetb main i.lnummer i.year if open_year!=., cluster(lnummer)
est store AKK1
*(column 3 - all municipalities)
reg ratetb main i.lnummer i.year , cluster(lnummer)
est store AKK2
esttab AKK1 AKK2, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table 7****************
*Long-term Effects of Access to a Mother and Child Health Care Center on Health at Age 40
************************
clear
use "data_individual_level.dta"

*keep individuals bron from 1936-1960
keep if yob>1935 & yob<1961
*drop Oslo and Bergen
drop if fodes==301|fodes==1201
*drop municiaplities outside of mainland Norway (e.g. Svalbard)
drop if fodes>2000
*drop if gender is missing
drop if female<0 | female==.
*drop if mother's id is missing
drop if nmpid==.

*keep observations included in the health surveys
keep if conor==1 | age40==1

*Health Index
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum health_index if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg health_index main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum health_index if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg health_index main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum health_index if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg health_index main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*BMI
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum bmi if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg bmi main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum bmi if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg bmi main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum bmi if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg bmi main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Obesity
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum obese if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg obese main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum obese if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg obese main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum obese if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg obese main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Blood Pressure
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum bloodp_s if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg bloodp_s main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum bloodp_s if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg bloodp_s main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum bloodp_s if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg bloodp_s main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Hypertension
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum high_bp if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg high_bp main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum high_bp if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg high_bp main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum high_bp if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg high_bp main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Cardiac Risk
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum risk_heart if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg risk_heart main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum risk_heart if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg risk_heart main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum risk_heart if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg risk_heart main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Cholesterol Risk
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum risk_colesterol if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg risk_colesterol main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum risk_colesterol if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg risk_colesterol main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum risk_colesterol if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg risk_colesterol main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*Height
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum height if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg height main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*prereform mean (column 3)
sum height if main==0 & fodes!=. & female==0
*(column 4 - baseline)
xi: quietly reg height main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==0, cluster(fodes)
est store AKK2
*prereform mean (column 5)
sum height if main==0 & fodes!=. & female==1
*(column 6 - baseline)
xi: quietly reg height main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if female==1, cluster(fodes)
est store AKK3
restore
esttab AKK1 AKK2 AKK3, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table 8****************
*Effects of Access to a Mother and Child Health Care Center on Missed School Days and Mother's Fertility
************************
clear
use "data_mdays.dta"
*Missed school days
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum missed if main==0
*(column 2 - baseline)
xi: quietly reg missed main i.lnummer i.year, cluster(lnummer)
est store AKK1
restore
esttab AKK1, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

clear
use "data_individual_level.dta"
*keep individuals bron from 1936-1960
keep if yob>1935 & yob<1961
*drop Oslo and Bergen
drop if fodes==301|fodes==1201
*drop municiaplities outside of mainland Norway (e.g. Svalbard)
drop if fodes>2000
*drop if gender is missing
drop if female<0 | female==.
*drop if mother's id is missing
drop if nmpid==.

*Fertility
preserve
*keep eventually open center 
drop if open==. 
*prereform mean (column 1)
sum fertility if main==0 & fodes!=.
*(column 2 - baseline)
xi: quietly reg fertility main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
esttab AKK1, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

************************
*Figure 1***************
*Infant Mortallity Rate Relative to the Opening Years of Mother and Child Health Care Centers
************************

use "mortality_figure.dta"

g time=0 if year==open_year
replace time=-1 if year==open_year+1
replace time=-2 if year==open_year+2
replace time=-3 if year==open_year+3
replace time=-4 if year==open_year+4
replace time=1 if year==open_year-1
replace time=2 if year==open_year-2
replace time=3 if year==open_year-3
replace time=4 if year==open_year-4

collapse (mean) rateall ratediarr ratepneu ratecong ratewhopp ratedip ratetb, by(time)
*Infant mortality
replace rateall=rateall*1000
twoway (scatter rateall time), xtitle(Year relative to opening of health care center) ytitle(Average infant mortality rate) xline(0) ylabel(10(5)35) ylabel(10(5)35) yscale(range(10 35)) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph save all, replace 
graph export "all.eps", as(eps) preview(off) replace 

*Infant mortality from congenital malformations
replace ratecong=ratecong*1000
twoway (scatter ratecong time), xtitle(Year relative to opening of health care center) ytitle(Average infant mortality rate (congenital malformations)) xline(0) ylabel(10(5)35) yscale(range(10 35)) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph save cong, replace 
graph export "congenital.eps", as(eps) preview(off) replace

*Infant mortality from pneumonia
replace ratepneu=ratepneu*1000
twoway (scatter ratepneu time), xtitle(Year relative to opening of health care center) ytitle(Average infant mortality rate (pneumonia)) xline(0) ylabel(10(5)35) yscale(range(10 35)) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph save pneumonia, replace 
graph export "pneumonia.eps", as(eps) preview(off) replace

*Infant mortality from diarrhea
replace ratediarr=ratediarr*1000
twoway (scatter ratediarr time), xtitle(Year relative to opening of health care center) ytitle(Average infant mortality rate (diarrhea)) xline(0) yscale(range(0 6)) ylabel(0(2)6) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph save diarrh, replace 
graph export "diarrhea.eps", as(eps) preview(off) replace

*Infant mortality from pertussis
replace ratewhopp=ratewhopp*1000
twoway (scatter ratewhopp time), xtitle(Year relative to opening of health care center) ytitle(Average infant mortality rate (pertussis)) xline(0) yscale(range(0 6)) ylabel(0(2)6) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph save whop, replace 
graph export "whopp.eps", as(eps) preview(off) replace

*Infant mortality from TB
replace ratetb=ratetb*1000
twoway (scatter ratetb time), xtitle(Year relative to opening of health care center) ytitle(Average infant mortality rate (tuberculosis)) xline(0)  yscale(range(0 6)) ylabel(0(2)6) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph save tb, replace 
graph export "tb.eps", as(eps) preview(off) replace


