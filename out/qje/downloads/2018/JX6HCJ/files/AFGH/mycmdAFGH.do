global cluster = ""

use DatAFGH, clear

global i = 1
global j = 1

*Table 1
mycmd (treat_hi) reg profit_main treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
mycmd (treat_hi) tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ul
mycmd (treat_hi) tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ul

*Table 2
mycmd (treat_hi) mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
mycmd (treat_hi) mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)

*Table 3
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)

*Table 4 
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
mycmd (treat_nosal treat_r) reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll
mycmd (treat_sal treat_nosal treat_r) tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll




