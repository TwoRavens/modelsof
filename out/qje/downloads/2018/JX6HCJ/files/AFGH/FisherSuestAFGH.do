
use DatAFGH, clear


*Table 1

global i = 1

reg profit_main treat_hi if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

reg time_total_work_min treat_hi if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
		estimates store M$i
		global i = $i + 1

tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
		estimates store M$i
		global i = $i + 1

tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul
		estimates store M$i
		global i = $i + 1

suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
test treat_hi
matrix F = (r(p), r(drop), r(df), r(chi2), 1)



*Table 2

global i = 1

mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

suest M1 M2 M3, robust
test [M1_3]treat_hi [M1_7]treat_hi [M2_3]treat_hi [M2_7]treat_hi [M3_3]treat_hi [M3_7]treat_hi
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)


*Table 3

global i = 1

mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

suest M1 M2 M3, robust
test [M1_3]treat_sal [M1_3]treat_nosal [M1_3]treat_r [M1_7]treat_sal [M1_7]treat_nosal [M1_7]treat_r [M2_3]treat_sal [M2_3]treat_nosal [M2_3]treat_r [M2_7]treat_sal [M2_7]treat_nosal [M2_7]treat_r [M3_3]treat_sal [M3_3]treat_nosal [M3_3]treat_r [M3_7]treat_sal [M3_7]treat_nosal [M3_7]treat_r
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)


*Table 4 

global i = 1

reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
		estimates store M$i
		global i = $i + 1

reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
		estimates store M$i
		global i = $i + 1

reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
		estimates store M$i
		global i = $i + 1

reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
		estimates store M$i
		global i = $i + 1

tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
		estimates store M$i
		global i = $i + 1

tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll
		estimates store M$i
		global i = $i + 1

*Dropping colinear tests

suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
test [M2_mean]treat_nosal [M3_mean]treat_nosal [M4_mean]treat_nosal [M5_mean]treat_nosal [M6_mean]treat_nosal [M7_model]treat_nosal [M8_model]treat_nosal [M9_model]treat_nosal [M1_mean]treat_r [M2_mean]treat_r [M3_mean]treat_r [M4_mean]treat_r [M5_mean]treat_r [M6_mean]treat_r [M7_model]treat_r [M8_model]treat_r [M9_model]treat_r [M4_mean]treat_sal [M5_mean]treat_sal [M6_mean]treat_sal [M8_model]treat_sal [M9_model]treat_sal 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
mata Y = st_data(.,("treat_hi","treat_nosal","treat_r","treat_lo","treat_sal"))

generate Order = _n
generate double U = .

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U 
	mata st_store(.,("treat_hi","treat_nosal","treat_r","treat_lo","treat_sal"),Y)

*Table 1

estimates clear

global i = 1

quietly reg profit_main treat_hi if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

quietly reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

quietly reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

quietly reg time_total_work_min treat_hi if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

quietly reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

quietly reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
		estimates store M$i
		global i = $i + 1

capture tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
if (_rc == 0) {
	capture test treat_hi
		if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 1)
		}
	}



*Table 2

estimates clear

global i = 1

capture mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test [M1_3]treat_hi [M1_7]treat_hi [M2_3]treat_hi [M2_7]treat_hi [M3_3]treat_hi [M3_7]treat_hi
		if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
		}
	}



*Table 3

estimates clear

global i = 1

capture mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test [M1_3]treat_sal [M1_3]treat_nosal [M1_3]treat_r [M1_7]treat_sal [M1_7]treat_nosal [M1_7]treat_r [M2_3]treat_sal [M2_3]treat_nosal [M2_3]treat_r [M2_7]treat_sal [M2_7]treat_nosal [M2_7]treat_r [M3_3]treat_sal [M3_3]treat_nosal [M3_3]treat_r [M3_7]treat_sal [M3_7]treat_nosal [M3_7]treat_r
		if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}



*Table 4 

estimates clear

global i = 1

quietly reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
		estimates store M$i
		global i = $i + 1

quietly reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
		estimates store M$i
		global i = $i + 1

quietly reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
		estimates store M$i
		global i = $i + 1

quietly reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

quietly reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

quietly reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
		estimates store M$i
		global i = $i + 1

capture tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll
		if (_rc == 0) estimates store M$i
		global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
if (_rc == 0) {
	capture test [M2_mean]treat_nosal [M3_mean]treat_nosal [M4_mean]treat_nosal [M5_mean]treat_nosal [M6_mean]treat_nosal [M7_model]treat_nosal [M8_model]treat_nosal [M9_model]treat_nosal [M1_mean]treat_r [M2_mean]treat_r [M3_mean]treat_r [M4_mean]treat_r [M5_mean]treat_r [M6_mean]treat_r [M7_model]treat_r [M8_model]treat_r [M9_model]treat_r [M4_mean]treat_sal [M5_mean]treat_sal [M6_mean]treat_sal [M8_model]treat_sal [M9_model]treat_sal 
		if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

}

drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
gen N = _n
sort N
svmat double F
save results\FisherSuestAFGH, replace







