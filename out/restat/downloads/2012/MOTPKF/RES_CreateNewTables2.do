cap log close

clear all

set more off

set memory 700m

use "newreplication.dta", clear

log using "CreateNewTables2_output.log", replace

xtset stcnty

*gen unusedlim = limit - bal
gen sc_black = pctblack * tr_am
gen sc_black_my = pctblack_my * tr_am

global demographics = " age gt_hs_male eq_hs_male gt_hs_female eq_hs_female nonmarried_male nonmarried_female widowed_male widowed_female divorced_male divorced_female foreignborn "
global incemp = " publicassistance employment income_10 income_15 income_20 income_25 income_30 income_35 income_40 income_45 income_50 income_60 income_75 income_100 income_125 income_150 income_200 "
global housing = " vacant ownocc withmort medianrent_b mhv "
global income = " income_10 income_15 income_20 income_25 income_30 income_35 income_40 income_45 income_50 income_60 income_75 income_100 income_125 income_150 income_200 "

global mydemographics = " age gt_hs_male_my eq_hs_male_my gt_hs_female_my eq_hs_female_my nonmarried_male_my nonmarried_female_my widowed_male_my widowed_female_my divorced_male_my divorced_female_my foreignborn_my "
global myincemp = "publicassistance_my employment_my income_10_my income_15_my income_20_my income_25_my income_30_my income_35_my income_40_my income_45_my income_50_my income_60_my income_75_my income_100_my income_125_my income_150_my income_200_my "
global myincome = " income_10_my income_15_my income_20_my income_25_my income_30_my income_35_my income_40_my income_45_my income_50_my income_60_my income_75_my income_100_my income_125_my income_150_my income_200_my "
global myhousing = " vacant_my ownocc_my withmort_my medianrent_b_my mhv_my "


gen holdpctblack = pctblack
gen holdscblack = sc_black
gen holdmypctblack = pctblack_my
gen holdmyscblack = sc_black_my

*sum availcredit pctblack tr_am sc_black $demographics $incemp $housing if insample1==1

* Table 3
xtset stcnty
xtreg availcredit pctblack tr_am if insample1==1, fe                                    * Column (2)
xtreg unusedlim pctblack tr_am if insample1==1, fe                                      * Column (3)
xtreg unusedlim pctblack tr_am if insample2==1, fe                                      * Column (4)
xtreg unusedlim pctblack tr_am $income if insample1==1, fe                              * Column (5)
test $income
xtreg unusedlim pctblack tr_am $demographics $incemp $housing if insample1==1, fe       * Column (6)

* Table 4
xtreg limit util_dol pctblack tr_am if insample1==1, fe                                 * Column (2)
xtreg limit bal pctblack tr_am if insample1==1, fe                                      * Column (3)
xtreg limit bal pctblack tr_am if insample2==1, fe                                      * Column (4)
xtreg limit bal pctblack tr_am $income if insample1==1, fe                              * Column (5)
test $income
xtreg limit bal pctblack tr_am $demographics $incemp $housing if insample1==1, fe       * Column (6)

* Table 5
xtreg availcredit pctblack sc_black tr_am if insample1==1, fe                                 * Column (2)
xtreg unusedlim pctblack sc_black tr_am if insample1==1, fe                                   * Column (3)
xtreg unusedlim pctblack sc_black tr_am if insample2==1, fe                                   * Column (4)
xtreg unusedlim pctblack sc_black tr_am $income if insample1==1, fe                           * Column (5)
test $income
xtreg unusedlim pctblack sc_black tr_am $demographics $incemp $housing if insample1==1, fe    * Column (6)
xtreg unusedlim pctblack sc_black tr_am $demographics $incemp $housing if insample2==1, fe    * Unreported

* Table 6
xtreg limit util_dol pctblack sc_black tr_am if insample1==1, fe                              * Column (2)
xtreg limit bal pctblack sc_black tr_am if insample1==1, fe                                   * Column (3)
xtreg limit bal pctblack sc_black tr_am if insample2==1, fe                                   * Column (4)
xtreg limit bal pctblack sc_black tr_am $income if insample1==1, fe                           * Column (5)
test $income
xtreg limit bal pctblack sc_black tr_am $demographics $incemp $housing if insample1==1, fe    * Column (6)
xtreg limit bal pctblack sc_black tr_am $demographics $incemp $housing if insample2==1, fe    * Unreported

drop if insample1==0
save /hmda/hmda1/m1kpb00/CohenCole/Work/ForBootstraps, replace


log close