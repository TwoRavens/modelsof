********************************************************
*                                                      *
* Predicting the Duration of the Syrian Insurgency     *
*                                                      *
* Replication Instructions: References to Lyall (2010) *
*                                                      *
* This Version: June 8, 2014                           *
*                                                      *
* Address correspondence to: tbohmelt@essex.ac.uk      *
*                                                      *
********************************************************

clear

use "Lyall Replication Data.dta"

******************
*                *
* Duration Setup *
*                *
******************

gen startdate2 = date(startdate, "DMY")
gen enddate2 = date(enddate, "DMY")
gen startdate3 = startdate2+ 5297
gen enddate3 = enddate2+5297
gen duration= enddate3- startdate3
sum duration

stset duration, failure(ended) 

************************
*                      *
* In-Sample Evaluation *
*                      *
************************

keep duration ended warid _st _d _t _t0 treat mech lelev lcinc nwstate ldis support numlang

streg, dist(weib) robust
predict meantime_empty_weib, time median
gen error_empty_weib_i= abs(meantime_empty_weib- _t)
gen error_empty_weib_i_run= sum(error_empty_weib_i)
egen error_empty_weib_all= max(error_empty_weib_i_run)

streg treat mech lelev lcinc nwstate ldis support numlang, dist(weibull) robust
predict meantime_weib_full, time median
gen error_full_weib_i= abs(meantime_weib_full- _t)
gen error_full_weib_i_run= sum(error_full_weib_i)
egen error_full_weib_all= max(error_full_weib_i_run)

gen PRE= (error_empty_weib_all- error_full_weib_all)/ error_empty_weib_all
sum PRE

sum error_full_weib_i
generate aerror=_t-meantime_weib_full
sum aerror

corr meantime_weib_full _t

****************************
*                          *
* Out-of-Sample Evaluation *
*                          *
****************************

gen non_missing_2=0
replace non_missing_2=1 if treat~=. & mech~=. & lelev~=. & lcinc~=. & nwstate~=. & ldis~=. & support~=. & numlang~=. 

gen test= uniform()
xtile out_of_sample= test, nq(10)
tabulate  out_of_sample, generate(out_of_sample_)

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' & non_missing_2==1, time median
quietly: gen error_weib_i= abs(meantime_weib- _t)
quietly: gen error_weib_i_run= sum(error_weib_i)
quietly: egen error_weib_all_`i'= max(error_weib_i_run)
quietly: drop  meantime_weib-  error_weib_i_run
}
quietly: tabstat error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5, stats(mean) save
matrix stats_error_empty_`j'=r(StatTotal)
quietly: drop error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg treat mech lelev lcinc nwstate ldis support numlang if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' & non_missing_2==1, time median
quietly: gen error_weib_i= abs(meantime_weib- _t)
quietly: gen error_weib_i_run= sum(error_weib_i)
quietly: egen error_weib_all_`i'= max(error_weib_i_run)
quietly: drop  meantime_weib-  error_weib_i_run
}
quietly: tabstat error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5, stats(mean) save
quietly: matrix stats_error=r(StatTotal)
quietly: matrix improve_absolut= stats_error_empty_`j'- stats_error
quietly: matrix D= improve_absolut\ stats_error_empty_`j'
quietly: matrix E= D'
quietly: svmat E
quietly: gen PRE_1= E1/ E2
quietly: gen PRE1_sum= sum(PRE_1)
quietly: egen PRE1_overall= max(PRE1_sum)
quietly: gen PRE_overall_Lyall_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_Lyall_10_mean= rowmean(PRE_overall_Lyall_10_1-  PRE_overall_Lyall_10_10)
egen PRE_Lyall_10_sd= rowsd(PRE_overall_Lyall_10_1-  PRE_overall_Lyall_10_10)
drop PRE_overall_Lyall_10_1-  PRE_overall_Lyall_10_10

sum PRE_Lyall_10_mean PRE_Lyall_10_sd
