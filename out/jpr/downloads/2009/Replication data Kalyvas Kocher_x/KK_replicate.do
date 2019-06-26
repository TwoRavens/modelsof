******************************************
** REPLICATION OF MODELS IN:            ** 
** KALYVAS AND KOOCHER,                 **
** The Dynamics of Violence in Vietnam: **
** An Analysis of the Hamlet Evaluation **
** System (HES), JPR 2009               **
******************************************

** Tables I - IV, VI - VII use "K&K_replication_data_h.dta" **
** Table V uses "K&K_replication_data_v.dta" **


** TABLE I **
tab mod3a_1

** TABLE II **
tab mod3a_1 sterror, row chi2

** TABLE III **
tab sterror_7_12 ever_in_4 if month == 7, col chi2

** TABLE IV **
set more off
xi: ologit sterror i.mod3a_1, cluster(usid)
xi: ologit sterror i.mod3a_1 urbrur1 urb_in_vil lnhpop score, cluster(usid)
xi: ologit sterror i.mod3a_1 urbrur1 urb_in_vil lnhpop score ln_dist std, cluster(usid)
xi: ologit sterror i.mod3a_1 urbrur1 urb_in_vil lnhpop score ln_dist std vietnamese buddhist, cluster(usid)

** TABLE V **
tab v_bomb mod2c_1amax, col chi2

** TABLE VI **
tab mod2c_1 bombed_bin, row chi2
sort mod2c_1
by mod2c_1: summ bombed

** TABLE VII **
** Note: generates predicted factor change of 3 models as temp2, temp4, temp6 **
set more off
xi: nbreg bombed i.mod2c_1, cluster(usid)
matrix D = e(b)
matrix D1 = D'
svmat D1, name(temp1)
gen temp2 = exp(temp1)

xi: nbreg bombed i.mod2c_1 month urbrur1 urb_in_vil lnhpop score ln_dist std, cluster(usid)
matrix D = e(b)
matrix D1 = D'
svmat D1, name(temp3)
gen temp4 = exp(temp3)

xi: nbreg bombed i.mod2c_1 month urbrur1 urb_in_vil lnhpop score ln_dist std buddhist vietnamese, cluster(usid)
matrix D = e(b)
matrix D1 = D'
svmat D1, name(temp5)
gen temp6 = exp(temp5)
