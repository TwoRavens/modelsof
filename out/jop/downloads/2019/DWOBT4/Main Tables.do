
log using Pooled_MainTablesText.txt, replace text


* syntax to replicate tables 1-5 in Fastfood paper

clear
set seed 1234567
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Pooled_All.dta"
* Table 1, Column 1 - logistic regression with covariate
bootstrap, reps(10000) cluster(case_id): logit outcome_card treat_dir pre_treat_freq i.stratum if data_set=="MTurk"
est sto m1
* Table 1, Column 2 - logistic regression without covariate
bootstrap, reps(10000) cluster(case_id): logit outcome_card treat_dir                i.stratum if data_set=="MTurk"
est sto m2
* Table 1, Column 3 - OLS regression with covariate
bootstrap, reps(10000) cluster(case_id): reg outcome_card treat_dir pre_treat_freq   i.stratum if data_set=="MTurk"
est sto m3
* Table 1, Column 4 - OLS regression without covariate
bootstrap, reps(10000) cluster(case_id): reg outcome_card treat_dir                  i.stratum if data_set=="MTurk"
est sto m4

esttab m1 m2 m3 m4 using table1_updated.doc, se


clear
set seed 1234567
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Pooled_All.dta"

** Recode individuals who skipped the future intentions outcome to "Never"
recode outcome_freq (.=1)
gen outcome_not_never=0
replace outcome_not_never = 1 if outcome_freq > 1
tab outcome_freq outcome_not_never

generate pre_treat_freq_fixed = pre_treat_freq
replace pre_treat_freq_fixed = pre_treat_freq+1 if data_set=="MTurk"

* Table 2, Column 1 - ordered logistic regression with covariate
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq treat_dir pre_treat_freq_fixed   i.stratum if data_set=="MTurk"
est sto m5
* Table 2, Column 2 - ordered logistic regression without covariate
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq treat_dir                        i.stratum if data_set=="MTurk"
est sto m6
* Table 2, Column 3 - OLS regression with covariate
bootstrap, reps(10000) cluster(case_id): regress outcome_freq treat_dir pre_treat_freq_fixed  i.stratum if data_set=="MTurk"
est sto m7
* Table 2, Column 4 - OLS regression without covariate
bootstrap, reps(10000) cluster(case_id): regress outcome_freq treat_dir                       i.stratum if data_set=="MTurk"
est sto m8
* Table 2, Column 5 - Binary outcome OLS regression with covariate
bootstrap, reps(10000) cluster(case_id): reg outcome_not_never treat_dir pre_treat_freq_fixed i.stratum if data_set=="MTurk"
est sto m9
* Table 2, Column 6 - Binary outcome OLS regression without covariate
bootstrap, reps(10000) cluster(case_id): reg outcome_not_never treat_dir                      i.stratum if data_set=="MTurk"
est sto m10

esttab m5 m6 m7 m8 m9 m10 using table2_updated.doc, se

* Table 3, Column 1 - ordered logistic regression
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq treat_dir    i.stratum if data_set=="CCES"
est sto m11
* Table 3, Column 2 - OLS regression
bootstrap, reps(10000) cluster(case_id): regress outcome_freq treat_dir   i.stratum if data_set=="CCES"
est sto m12
* Table 3, Column 3 - Binary outcome OLS regression
bootstrap, reps(10000) cluster(case_id): reg outcome_not_never treat_dir  i.stratum if data_set=="CCES"
est sto m13
esttab m11 m12 m13 using table3_updated.doc, se


* Table 4, Column 1 - ordered logistic regression with covariate
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq treat_dir pre_treat_freq_fixed   i.stratum if data_set=="YG"
est sto m14
* Table 4, Column 2 - ordered logistic regression without covariate
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq treat_dir                        i.stratum if data_set=="YG"
est sto m15
* Table 4, Column 3 - OLS regression with covariate
bootstrap, reps(10000) cluster(case_id): regress outcome_freq treat_dir pre_treat_freq_fixed  i.stratum if data_set=="YG"
est sto m16
* Table 4, Column 4 - OLS regression without covariate
bootstrap, reps(10000) cluster(case_id): regress outcome_freq treat_dir                       i.stratum if data_set=="YG"
est sto m17
* Table 4, Column 5 - Binary Outcome OLS regression with covariate
bootstrap, reps(10000) cluster(case_id): reg outcome_not_never treat_dir pre_treat_freq_fixed i.stratum if data_set=="YG"
est sto m18
* Table 4, Column 6 - Binary Outcome OLS regression without covariate
bootstrap, reps(10000) cluster(case_id): reg outcome_not_never treat_dir                      i.stratum if data_set=="YG"
est sto m19
esttab m14 m15 m16 m17 m18 m19 using table4_updated.doc, se



* pooled results (not in table but in text on page 21)
** Set the pre treatment frequency to the mean for the CCES
recode pre_treat_freq_fixed (.=2.164755)

ologit outcome_freq treat_dir pre_treat_freq_fixed i.stratum
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq treat_dir pre_treat_freq_fixed    i.stratum
reg outcome_freq treat_dir pre_treat_freq_fixed i.stratum
bootstrap, reps(10000) cluster(case_id): reg outcome_freq treat_dir pre_treat_freq_fixed i.stratum


* Table 5
tab partyid7

gen strong = 0
replace strong = 1 if partyid7=="Strong_Dem" | partyid7=="Strong_Rep"

gen strong_treat = strong*treat_dir
gen weak_treat = (1-strong)*treat_dir


bootstrap, reps(10000) cluster(case_id): ologit outcome_freq strong_treat weak_treat strong pre_treat_freq_fixed i.stratum if data_set=="MTurk"
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq strong_treat weak_treat strong pre_treat_freq_fixed i.stratum if data_set=="CCES"
bootstrap, reps(10000) cluster(case_id): ologit outcome_freq strong_treat weak_treat strong pre_treat_freq_fixed i.stratum if data_set=="YG"

bootstrap, reps(10000) cluster(case_id): ologit outcome_freq strong_treat weak_treat strong pre_treat_freq_fixed i.stratum


* test for difference in treatment effects
clear
set seed 1234567
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/Pooled_All.dta"
tab partyid7

recode outcome_freq (.=1)
gen outcome_not_never=0
replace outcome_not_never = 1 if outcome_freq > 1
tab outcome_freq outcome_not_never

generate pre_treat_freq_fixed = pre_treat_freq
replace pre_treat_freq_fixed = pre_treat_freq+1 if data_set=="MTurk"


gen strong = 0
replace strong = 1 if partyid7=="Strong_Dem" | partyid7=="Strong_Rep"

gen strong_treat = strong*treat_dir
gen weak_treat = (1-strong)*treat_dir

** Set the pre treatment frequency to the mean for the CCES
recode pre_treat_freq_fixed (.=2.164755)

bootstrap diff=(_b[strong_treat]), reps(10000) saving(file_MTurk) cluster(case_id): ologit outcome_freq treat_dir strong_treat strong pre_treat_freq_fixed i.stratum if data_set=="MTurk"
bootstrap diff=(_b[strong_treat]), reps(10000) saving(file_CCES) cluster(case_id): ologit outcome_freq treat_dir strong_treat strong pre_treat_freq_fixed i.stratum if data_set=="CCES"
bootstrap diff=(_b[strong_treat]), reps(10000) saving(file_YG) cluster(case_id): ologit outcome_freq treat_dir strong_treat strong pre_treat_freq_fixed i.stratum if data_set=="YG"

bootstrap diff=(_b[strong_treat]), reps(10000) saving(file_all) cluster(case_id): ologit outcome_freq treat_dir strong_treat strong pre_treat_freq_fixed i.stratum

clear

** Mturk p-value
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/file_MTurk.dta"
tab diff if diff <0
dis 581/10000
clear

** CCES p-value
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/file_CCES.dta"
tab diff if diff <0
dis 1287/10000
clear

** YG p-value
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/file_YG.dta"
tab diff if diff <0
dis 4730/10000
clear

** All studies pooled p-value
use "/Users/kyleendres/Dropbox/OSI Research Working Group/FastFood/Writeup/JOP/Replication Data and Code/file_all.dta"
tab diff if diff <0
dis 265/10000

log close

