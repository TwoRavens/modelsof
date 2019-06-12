
****************************************
****************************************

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

suest M1 M2 M3 M4 M5 M6 M7 M8 M9, robust
test treat_sal treat_nosal treat_r
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

drop _all
svmat double F
save results/SuestAFGH, replace


