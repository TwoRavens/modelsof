
use "/Users/b1010576/Dropbox/LenaGabi_Globalisierung/Ueberarbeitung_May_2010/PSRM/Replication/Data_Schaffer_Spilker_2014.dta", clear

*******Table 3**********
**Random Intercept logistic model - baseline model

xtmelogit global2 lopenc_m alm_exp_m educ_years income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m alm_exp_m winner1 income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m unemp_exp_m educ_years income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m unemp_exp_m winner1 income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)


*******Table 4**********
**random coefficient model: 4th income and globalization

capture gen trade_income4=income4*lopenc_m
xtmelogit global2 lopenc_m alm_exp_m  trade_income4 educ_years income2 income3 income4  gender v331  left1 left3  || cowcode: income4, intpoints(10) cov(unstructured)

capture gen alm_income=income4*alm_exp_m
xtmelogit global2 lopenc_m alm_exp_m  alm_income educ_years income2 income3 income4  gender v331  left1 left3  || cowcode: income4, intpoints(10) cov(unstructured)

*random coefficient model: education and globalization

gen trade_educ=educ_years*lopenc_m
xtmelogit global2 lopenc_m alm_exp_m  trade_educ educ_years income2 income3 income4  gender v331  left1 left3  || cowcode: educ_years, intpoints(10) cov(unstructured)

capture gen alm_educ=educ_years*alm_exp_m
xtmelogit global2 lopenc_m alm_exp_m  alm_educ educ_years income2 income3 income4  gender v331  left1 left3  || cowcode: educ_years, intpoints(10) cov(unstructured)

*random coefficient model: winner and globalization

gen trade_win=winner1*lopenc_m
xtmelogit global2 lopenc_m alm_exp_m  trade_win winner1 income2 income3 income4  gender v331  left1 left3  || cowcode: winner1, intpoints(10) cov(unstructured)

capture gen alm_win=winner1*alm_exp_m
xtmelogit global2 lopenc_m alm_exp_m  alm_win winner1 income2 income3 income4  gender v331  left1 left3  || cowcode: winner1, intpoints(10) 



********Robustness*********

*******Table 5**********
**Random Intercept logistic model - different macro level variables

xtmelogit global2 FDIpcGDP_m alm_exp_m educ_years income2 income3 income4  gender v331  left1 left3  || cowcode:, intpoints(10)

xtmelogit global2 outFDIpcGDP_m alm_exp_m educ_years income2 income3 income4  gender v331  left1 left3  || cowcode:, intpoints(10)

xtmelogit global2 kof_m alm_exp_m educ_years income2 income3 income4  gender v331  left1 left3  || cowcode:, intpoints(10)

xtmelogit global2 openc_ch alm_exp_m educ_years income2 income3 income4  gender v331  left1 left3  || cowcode:, intpoints(10)

xtmelogit global2 openc_ch alm_exp_m unemploy grgdpch  educ_years income2 income3 income4  gender v331  left1 left3  || cowcode:, intpoints(10)




*******Table 6**********
**Random Intercept logistic model - controlling for information

xtmelogit global2 lopenc_m alm_exp_m educ_years income2 income3 income4  gender v331  left1 left3  info_EU  info_tax || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m alm_exp_m winner1 income2 income3 income4  gender v331  left1 left3  info_EU info_tax  || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m unemp_exp_m educ_years income2 income3 income4  gender v331  left1 left3 info_EU info_tax  || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m unemp_exp_m winner1 income2 income3 income4  gender v331  left1 left3  info_EU info_tax || cowcode:, intpoints(10)


*******Table 7**********
**Random Intercept logistic model - different specifications for winner variable

xtmelogit global2 lopenc_m alm_exp_m winner2 income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m alm_exp_m winner3 income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)

xtmelogit global2 lopenc_m alm_exp_m winner4 income2 income3 income4  gender v331  left1 left3   || cowcode:, intpoints(10)




*******Table 2**********
**Summary statistics
sum winner1 income2 income3 income4 educ_years gender v331  left1 left3



*******Table 1**********
**Summary statistics
tab country global2

***Summary statistics for those variables that vary on the national level only
sort cowcode
by cowcode: gen ind=_n
drop if ind!=1
list country openc_m alm_exp_m unemp_exp_m





