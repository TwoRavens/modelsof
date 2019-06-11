*** NOTE
*** The base data set is organized as a time-series cross-section 
*** with agency head-years as the unit of analysis. Each individual 
*** head has a unique identification number and is observed once for 
*** each caldendar year that they remained in position. We use this 
*** version of the dataset for all graphs and descriptive statistics 
*** included in the paper and online appendix. Note, however, that in 
*** order to replicate the duration models presented in the paper, 
*** the dataset must first be transformed from "snapshot data" to 
*** "time-span data". Below, we include the code for the descriptive 
*** statistics, transformation, as well as the models.


***DESCRIPTIVES

*Frequency of exits by years on post (Figure 1, article)
graph twoway (bar gra_tenurecount1 gra_tenuret, bcolor(gs6)) (bar gra_tenurecount2 gra_tenuret, bcolor(gs10)), ysize(3) xsize(4) xlabel(0(5)30) ytitle("Event count") scheme(s1mono) 

*Proportion of exits by calendar year (Figure 2, article)
twoway (bar gra_exitprop year_cal if cov_libcon==0, bcolor(gs6)) (bar gra_exitprop year_cal if cov_libcon==1, bcolor(gs10) lcolor(black)), scheme(s1mono) ysize(3) xsize(4) yscale(range(0.0 0.1 0.3)) ymtick(0.00(0.05)0.30) ylabel(0.0(0.1)0.3, format(%5.1f)) xlabel(1960(10)2010) xtitle(Calendar year) ytitle(Proportion of exits) legend(cols(2) row(2) label(1 "Social Democratic Government") label(2 "Liberal-Conservative Government"))

*Agency head exits by calendar year (Figure 1, appendix)
twoway (bar gra_exitcount year_cal if cov_libcon==0, bcolor(gs6)) (bar gra_exitcount year_cal if cov_libcon==1, bcolor(gs10) lcolor(black)), scheme(s1mono) yscale(range(0 20 80)) ymtick(0.00(0.05)0.30) ylabel(0 20 40 60 80) xlabel(1960(10)2010) xtitle(Calendar Year) ytitle(Exits) legend(cols(2) row(2) label(1 "Social Democratic Government") label(2 "Liberal-Conservative Government")) title(Figure 1. Agency Head Exits by Calendar Year.) ysize(3) xsize(4)

*Descriptive statistics (Table 1, appendix)
sum cov_cabtur cov_polinc cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth cov_pre87


***DATA TRANSFORMATION

gen date1=year_cal // time indicator for convenience
snapspan head_id date1 head_exit cov_polinc cov_newter cov_eleyear cov_cabtur cov_growth cov_libcon year_cal, gen(date0) clear // change data structure from snapshot to time-span
drop if agency_id==. // drop redundant observations


***DURATION MODELS

*MICE Cox models, Cabinet turnover
set seed 999 // set random seed for replication
mi set flong // switch to long format		
mi stset date1, failure(head_exit) id(head_id) origin(year_app) // designate data set as imputed survival data
drop if _st==0 // drop unused observations
sts gen HT=na // generate Nelson-Aalen cumulative hazard
mi register imputed cov_pubsec cov_acasec cov_polsec cov_prisec // register covariates for imputation 
mi impute chained (logit) cov_polsec cov_pubsec cov_acasec cov_prisec = cov_cabtur cov_sex cov_libcon cov_growth2 cov_pre87 cov_eleyear cov_newter head_exit HT, add(20) // impute 20 datasets

set cformat %3.2f // switch to more sensible decimals
set matsize 700 // increase matsize for random-coeffcient model

mi estimate, dots hr: stcox cov_cabtur, efron cluster(agency_id) // Appendix Model 1
mi estimate, dots hr: stcox cov_cabtur cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex, efron cluster(agency_id) // Appendix Model 2
mi estimate, dots hr: stcox cov_cabtur cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron cluster(agency_id) // Appendix Model 3
mi estimate, dots hr: stcox cov_cabtur cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron cluster(agency_id) // Article Model 1, Appendix Model 4
mi estimate, dots hr: stcox cov_cabtur cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron strata(agency_id) cluster(agency_id) // Article Model 2, Appendix Model 5
mi estimate, dots hr: stcox cov_cabtur cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron shared(agency_id) forceshared // Article Model 3, Appendix Model 6 (slow)

*MICE Cox models, Policy incongruence
set seed 999 // set random seed for replication
mi set flong // switch to long format		
mi stset date1, failure(head_exit) id(head_id) origin(year_app) // designate data set as imputed survival data
drop if _st==0 // drop unused observations
sts gen HT=na // generate Nelson-Aalen cumulative hazard
mi register imputed cov_pubsec cov_acasec cov_polsec cov_prisec // register covariates for imputation 
mi impute chained (logit) cov_polsec cov_pubsec cov_acasec cov_prisec = cov_polinc cov_sex cov_libcon cov_growth2 cov_pre87 cov_eleyear cov_newter head_exit HT, add(20) // impute 20 datasets

set cformat %3.2f // switch to more sensible decimals
set matsize 700 // increase matsize for random-coeffcient model

mi estimate, dots hr: stcox cov_polinc, efron cluster(agency_id) // Appendix Model 1
mi estimate, dots hr: stcox cov_polinc cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex, efron cluster(agency_id) // Appendix Model 2
mi estimate, dots hr: stcox cov_polinc cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron cluster(agency_id) // Appendix Model 3
mi estimate, dots hr: stcox cov_polinc cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron cluster(agency_id) // Article Model 4, Appendix Model 4
mi estimate, dots hr: stcox cov_polinc cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron strata(agency_id) cluster(agency_id) // Article Model 5, Appendix Model 5
mi estimate, dots hr: stcox cov_polinc cov_acasec cov_polsec cov_prisec cov_pubsec cov_sex cov_libcon cov_newter cov_eleyear cov_growth2 cov_pre87, efron shared(agency_id) forceshared // Article Model 6, Appendix Model 6 (slow)


