/* This program produces all tables for the ORG CPS data used by Bollinger and Hirsch it does not creat the data set */

cd C:\imputations\selection\forREstat

capture log close

set more off

log using restatorg.log, replace


use C:\imputations\selection\forREstat\BHrestatorg, clear


/* Table 1, full sample imputation/missing rates */


tab1 impute1 impute2
tab1 impute1 impute2  [fweight = earnwt]


/* primary analysis sample */

drop if age < 18
drop if age > 65
drop if pt
drop if enrollft == 1


/* Table 1, primary sample imputation/missing rates */

tab1 impute1 impute2
tab1 impute1 impute2  [fweight = earnwt]


table year
table year [aweight = wt] , contents(freq mean impute2) 

tab proxy impute2 [aweight = wt], row col cell

gen bigprox = "self"
replace bigprox = "spouse" if spouseprox
replace bigprox = "nonspous" if nspouseprox

tab bigprox

table bigprox [aweight = wt],  contents(mean impute2)

gen imonth = "other"
replace imonth = "feb" if feb
replace imonth = "march" if march
tab imonth

table imonth [aweight = wt], contents(freq mean impute2)
tab imonth

/* table 2, primary sample */

tab proxy spouseprox, row col cell

tab proxy spouseprox if !female, row col cell
tab proxy spouseprox if female, row col cell




/* appendix table A1: weighted means by response status */


sort impute2 

by impute2: sum age feb march ed_elem hsdrop sch_hs sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd female white hispanic black asian size1 size2 size3 size4 size5 size6 size7 ne ma enc wnc sa esc wsc mt pac proxy feb march a_ind a_occ a_member rwage2 [aweight = wt]


/* Table 3 and appendix table A2, primary sample */

gen responder = 1 - impute2

dprobit responder feb march nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female

dprobit responder feb march nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female


/* table 4 and appendix tables A3 through A6 */

/* primary sample */
/* men */

/*OLS */

reg lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female

predict olshat

/* heckman two step with proxy in exclusions */

heckman lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female, select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

/* heckman two step with proxy in main equation */

heckman lrwage2 nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female, select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

predict selecthat


/* women */

/*OLS */

reg lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female

predict temp

replace olshat = temp if female

drop temp

/* heckman two step with proxy in exclusions */

heckman lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female, select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

/* heckman two step with proxy in main equation */

heckman lrwage2 nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female, select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

predict temp

replace selecthat = temp if female

drop temp

/* cohead sample */ 




/* men */

/*OLS */

reg lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female&(relhead < 4)

predict olshatcohead

/* heckman two step with proxy in exclusions */

heckman lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female&(relhead < 4), select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

/* heckman two step with proxy in main equation */

heckman lrwage2 nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if !female&(relhead < 4), select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

predict selecthatcohead


/* women */

/*OLS */

reg lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female&(relhead < 4)

predict temp

replace olshatcohead = temp if female

drop temp

/* heckman two step with proxy in exclusions */

heckman lrwage2 ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female&(relhead < 4), select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

/* heckman two step with proxy in main equation */

heckman lrwage2 nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp black asian other hispanic for_nonctz for_ctz  size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac pub_fedall pub_state pub_local member _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108 if female&(relhead < 4), select (feb march  nspouseprox spouseprox ed_elem sch_9 sch_10 sch_11 sch_12 sch_some ed_assoc sch_ba sch_ma sch_pro sch_phd exp expsq expcub expquar _msp _mnsp hispanic black asian other for_nonctz for_ctz pub_fedall pub_state pub_local member size2 size3 size4 size5 size6 size7 ma enc wnc sa esc wsc mt pac _bi01-_bi03 _bi05-_bi12 _mi01-_mi03 _mi05-_mi12 _bocc01-_bocc03 _bocc05-_bocc13 _mocc01-_mocc03 _mocc05-_mocc10 year99-year108) two

predict temp

replace selecthatcohead = temp if female

drop temp


/* table 5 */

table female, contents(mean lrwage mean lrwage2 mean olshat mean selecthat)

table female if (relhead < 4), contents(mean lrwage mean lrwage2 mean olshatcohead mean selecthatcohead)


log close

