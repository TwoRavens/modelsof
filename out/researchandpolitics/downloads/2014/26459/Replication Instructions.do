****************************************************
*                                                  *
* Predicting the Duration of the Syrian Insurgency *
*                                                  *
* Replication Instructions                         *
*                                                  *
* This Version: June 8, 2014                       *
*                                                  *
* Address correspondence to: tbohmelt@essex.ac.uk  *
*                                                  *
****************************************************

clear

use "Counterinsurgency Data.dta"

*******************************************
*                                         *
* Single-Predictor Out-of-Sample Exercise *
*                                         *
* Appendix Table I                        *
*                                         *
*******************************************

foreach var of varlist elev ldis lmtnest ncontig lnlandar numlang numlang_sq ethfrac ethfrac_sq plural second relfrac relfrac_sq plurrel minrelpc exclgrps exclpop strictvetos originalgroup splinterfaction externalstate neutral intervention SoS_insurgency eeurop lamerica ssafrica nafrme asia support coldwar3 contraband oppmil gdpen lgdpenl1 popl1 lpopl1 regime regime_sq democ anocracy instab Oil milper milper_ln force_ratio force_space heli mech vec cinc power enerpc lenerpc tradegdp ltradegdp strategy strategy_con govmil govecon {

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg `var' if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

}

*************************************************
*                                               *
* Predictor Combinations Out-of-Sample Exercise *
*                                               *
* Appendix Table I                              *
*                                               *
*************************************************

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg numlang numlang_sq if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ethfrac ethfrac_sq if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg plural second if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg relfrac relfrac_sq if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg plurrel minrelpc if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg exclgrps exclpop if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg exclgrps exclpop excl_groups_pop if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg regime regime_sq if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg democ anocracy if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

********************************************
*                                          *
* Dropping "Top-10" Variables Successively *
*                                          *
* Appendix Table II                        *
*                                          *
********************************************

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg second SoS_insurgency support coldwar3 contraband anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig SoS_insurgency support coldwar3 contraband anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second support coldwar3 contraband anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency coldwar3 contraband anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support contraband anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support coldwar3 anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support coldwar3 contraband heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support coldwar3 contraband anocracy strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support coldwar3 contraband anocracy heli govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support coldwar3 contraband anocracy heli strategy_con if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

***********************************************************
*                                                         *
* Progressive Elimination of Variables and PRE Assessment *
*                                                         *
* Appendix Table III                                      *
*                                                         *
***********************************************************

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second SoS_insurgency support coldwar3 contraband anocracy heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second support coldwar3 contraband heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second support coldwar3 heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second coldwar3 heli strategy_con govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg ncontig second coldwar3 heli govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg second coldwar3 heli govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg second coldwar3 govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

forvalues j=1/10 {
forvalues i=1/5 {
quietly: streg if out_of_sample_`j'~=`i' &  non_missing_2==1, dist(weib) robust 
quietly: predict meantime_weib if out_of_sample_`j'==`i' &  non_missing_2==1, time median
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
quietly: streg second govecon if out_of_sample_`j'~=`i' & non_missing_2==1, dist(weib) robust 
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
quietly: gen PRE_overall_regime_sq_10_`j'= PRE1_overall/ 5
quietly: matrix drop stats_error improve_absolut D E
quietly: drop E1 E2 PRE_1 PRE1_sum PRE1_overall error_weib_all_1 error_weib_all_2 error_weib_all_3 error_weib_all_4 error_weib_all_5
}

egen PRE_regime_sq_10_mean= rowmean(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
egen PRE_regime_sq_10_sd= rowsd(PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10)
drop PRE_overall_regime_sq_10_1-  PRE_overall_regime_sq_10_10
sum PRE_regime_sq_10_mean PRE_regime_sq_10_sd
drop PRE_regime_sq_10_mean PRE_regime_sq_10_sd

***********************************************************************************************************
*                                                                                                         *
* Final Model - In-Sample Prediction                                                                      *
*                                                                                                         *
* Main Text Table I and Descriptions (Absolute Error, Underprediction, and Substantive Effects (in Days)) *
*                                                                                                         *
***********************************************************************************************************

streg, dist(weib) robust nohr
predict meantime_empty_weib, time median
gen error_empty_weib_i= abs(meantime_empty_weib- _t)
gen error_empty_weib_i_run= sum(error_empty_weib_i)
egen error_empty_weib_all= max(error_empty_weib_i_run)

streg ncontig second contraband support govecon coldwar3 heli strategy_con, dist(weib) robust nohr
predict meantime_weib_full, time median
gen error_full_weib_i= abs(meantime_weib_full- _t)
gen error_full_weib_i_run= sum(error_full_weib_i)
egen error_full_weib_all= max(error_full_weib_i_run)

gen PRE=(error_empty_weib_all- error_full_weib_all)/error_empty_weib_all
sum PRE

corr meantime_weib_full _t
generate abso_error=abs(_t-meantime_weib_full)
sum abso_error
generate aerror=_t-meantime_weib_full
sum aerror

preserve
version 13
estsimp weibull _t ncontig second contraband support govecon coldwar3 heli strategy_con, robust nohr
setx median 
simqi, fd(ev) changex(ncontig min max) level(95)
simqi, fd(ev) changex(second min max) level(95)
simqi, fd(ev) changex(contraband min max) level(95)
simqi, fd(ev) changex(support min max) level(95)
simqi, fd(ev) changex(govecon min max) level(95)
simqi, fd(ev) changex(coldwar3 min max) level(95)
simqi, fd(ev) changex(heli min max) level(95)
simqi, fd(ev) changex(strategy_con min max) level(95)
restore

************
*          *
* Figure 1 *
*          *
************

gen _t_year= _t/ 365
gen  meantime_weib_year= meantime_weib_full/ 365
twoway (scatter _t_year  meantime_weib_year) (lfit _t_year meantime_weib_year, clpattern(dash) clwidth(thin) clcolor(black)), legend(off) scheme(lean1) xtitle("Predicted Insurgency Duration in Years", size(3.5)) ytitle("Observed Insurgency Duration in Years", size(3.5)) aspectratio(1)
drop  meantime_empty_weib-meantime_weib_year

************
*          *
* Table II *
*          *
************

preserve

keep _t _st _d _t0 warid war ncontig second contraband support govecon coldwar3 heli strategy_con

streg ncontig second contraband support govecon coldwar3 heli strategy_con, dist(weib) robust nohr
predictnl meantime_weib_full = predict(time median), se(med_se)
gen meantime_weib_year= meantime_weib_full/365
gen meantime_weib_year_stderr=med_se/365

list war meantime_weib_year meantime_weib_year_stderr if warid==.

gen adj_time=(meantime_weib_full+794.7711)/365

list war adj_time if warid==.

restore

*************
*           *
* Table III *
*           *
*************

display (6.344274*0.25)+(2.012766*0.25)+(2.944254*0.5)

display (8.521729*0.25)+(4.190221*0.25)+(5.121709*0.5)
