
**************************************

*All regressions okay

use AER-2008-1240_R1_AbelerFalkGoetteHuffman2009_data_file.dta, clear
tab controls_temperature, gen(CT)
tab controls_time_of_day, gen(CTD)

*Table 1 - All okay
reg profit_main treat_hi if (treat_lo | treat_hi)
reg profit_main treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
xi: reg profit_main treat_hi neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_hi)
reg profit_main treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
reg time_total_work_min treat_hi if (treat_lo | treat_hi)
reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
xi: reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_hi)
reg time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)
tobit time_total_work_min treat_hi if (treat_lo | treat_hi), ll(0) ul(60)
tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi), ll(0) ul(60)
xi: tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_hi), ll(0) ul(60)
tobit time_total_work_min treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi), ll(0) ul(60)

*Table 2 - All okay
mlogit pm_3_7_else treat_hi if (treat_lo | treat_hi)
mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt if (treat_lo | treat_hi)
xi: mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_hi)
mlogit pm_3_7_else treat_hi neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_hi)

*Table 3 - All okay
mlogit pm_3_7_else treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
xi: mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_nosal | treat_r | treat_sal)
mlogit pm_3_7_else treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)

*Table 4 - All okay
reg profit_main treat_nosal treat_r if (treat_lo | treat_nosal | treat_r)
reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal |treat_r)
xi: reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_nosal |treat_r)
reg profit_main treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal |treat_r)
reg ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal)
reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo | treat_nosal | treat_r | treat_sal)
xi: reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_nosal | treat_r | treat_sal)
reg ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal)
tobit ws treat_sal treat_nosal treat_r if (treat_lo | treat_nosal | treat_r | treat_sal), ll(0)
tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt if ( treat_lo | treat_nosal | treat_r | treat_sal), ll(0)
xi: tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo | treat_nosal | treat_r | treat_sal), ll(0)
tobit ws treat_sal treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo | treat_nosal | treat_r | treat_sal), ll(0)

* Table 5 - All okay - Treatment results not reported in table - so don't analyze these
reg distance_to_f sum_la if (treat_lo|treat_hi|treat_nosal|treat_r) & !inconsistent_lotteries
reg distance_to_f sum_la treat_hi treat_nosal treat_r if (treat_lo|treat_hi|treat_nosal|treat_r) & !inconsistent_lotteries
reg distance_to_f sum_la treat_hi treat_nosal treat_r neg_avg_time_cor_ans_pt if (treat_lo|treat_hi|treat_nosal|treat_r) & !inconsistent_lotteries
xi: reg distance_to_f sum_la treat_hi treat_nosal treat_r neg_avg_time_cor_ans_pt female i.controls_temperature i.controls_time_of_day if (treat_lo|treat_hi|treat_nosal|treat_r) & !inconsistent_lotteries
reg distance_to_f sum_la treat_hi treat_nosal treat_r neg_avg_time_cor_ans_pt female CT1 CT3 CTD2-CTD3 if (treat_lo|treat_hi|treat_nosal|treat_r) & !inconsistent_lotteries

*Sessional indicator somewhat inconsistently coded - sometimes it covers an entire day, sometimes it is divided between am and pm
*I noted that treatments never varied within an am or pm session, but could vary across am/pm within a day
*So, I redefine a session as an am or pm session
*This will not matter for main analysis, as I rerandomize at their chosen clustering level (i.e., none = individual)
*Only matters when I reanalyze (for appendix) rerandomizing at treatment grouping level

save DatAFGH, replace
