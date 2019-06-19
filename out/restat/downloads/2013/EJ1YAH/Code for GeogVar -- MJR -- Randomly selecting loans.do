log using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Logs\20091029 Random selection summs -- purch_frm_50.log", replace



********************************************************************************
********************************************************************************
*** Randomly selects loans from each MSA data file for a given loan category ***
*** -- also presents summs from full data set and from selected loans, so    ***
***    one can verify that the selection is reasonably representative        ***
********************************************************************************
********************************************************************************



*** NOTE:  This file was run four times, once for each loan category.  Due to computer memory limits and different numbers ***
***        of loans in the raw data, different percentages of loans were randomly selected for each loan category:         ***
***              purchase FRMs -- 50%                                                                                      ***
***              refinance FRMs -- 20%                                                                                     ***
***              purchase ARMs -- 20%                                                                                      ***
***              refinance ARMs -- 10%                                                                                     ***
***        The "p(#)" term in the egen statements below control the percentage of loans selected                           ***
***        The randomly selected loans were used in analyses in which loans from all ten MSAs were pooled.  In analyses in ***
***        which each MSA's loans were examined separately, all of each MSA's loans were used.                             ***



********************************************************************
*** Randomly selecting 50% of loans for each MSA's purchase FRMs ***
********************************************************************


 
*** MSA:       "Atlanta\atlanta" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Atlanta\atlanta_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Atlanta\atlanta_both_purch_frm generated_50.dta", replace






*** MSA:       "Baltimore\baltimore" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Baltimore\baltimore_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Baltimore\baltimore_both_purch_frm generated_50.dta", replace






*** MSA:       "Chicago\chicago" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Chicago\chicago_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Chicago\chicago_both_purch_frm generated_50.dta", replace






*** MSA:       "LosAngeles\losangeles" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\LosAngeles\losangeles_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\LosAngeles\losangeles_both_purch_frm generated_50.dta", replace






*** MSA:       "Miami\miami" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Miami\miami_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Miami\miami_both_purch_frm generated_50.dta", replace






*** MSA:       "Minneapolis\minneapolis" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Minneapolis\minneapolis_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Minneapolis\minneapolis_both_purch_frm generated_50.dta", replace






*** MSA:       "NewYork\newyork" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\NewYork\newyork_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\NewYork\newyork_both_purch_frm generated_50.dta", replace






*** MSA:       "Phoenix\phoenix" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Phoenix\phoenix_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Phoenix\phoenix_both_purch_frm generated_50.dta", replace






*** MSA:       "Pittsburgh\pittsburgh" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_both_purch_frm generated_50.dta", replace






*** MSA:       "SanAntonio\sanantonio" ***
*** Category:  purch_frm ***

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\SanAntonio\sanantonio_both_purch_frm generated.dta", clear
summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

bysort loan_id_num (currmonth): generate loan_count = 1 if currmonth == currmonth[1]
generate rand_num = 1+int(10000000*runiform()) if loan_count == 1
egen pctle_random_num = pctile(rand_num), p(50)
bysort loan_id_num (currmonth): egen random_num = max(rand_num)
keep if random_num < pctle_random_num
drop loan_count rand_num pctle_random_num random_num

summ if fico > 0 & cltv != 0 & balance != 0 & outcome_a != . & outsample_a != . & outcome_b != . & outsample_b != . & outcome_c != . & prepay_pen != . & prepay_pen_end != . & lownodoc != . & fico != . & cltv != . & ageofloan != . & ageofloan_2 != . & rel_loan_size != . & chg_unempl != . & hpa != . & var_hpi != . & judicial != . & var_6molibor != . & payment_adj != . & adj_1st != . & post_adj_1st != . & spread != . & vint2002 != . & vint2003 != . & vint2004 != . & vint2005 != . & vint2006 != .

save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\SanAntonio\sanantonio_both_purch_frm generated_50.dta", replace






******************************
*** Appending 10 MSA files ***
******************************



use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Atlanta\atlanta_both_purch_frm generated_50.dta", clear
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Baltimore\baltimore_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Chicago\chicago_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\LosAngeles\losangeles_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Miami\miami_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Minneapolis\minneapolis_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\NewYork\newyork_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Phoenix\phoenix_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\Pittsburgh\pittsburgh_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



append using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\MSA Level\SanAntonio\sanantonio_both_purch_frm generated_50.dta"
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



*** Generate MSA indicator variables ***
****************************************

generate msa_atl = 0
replace msa_atl = 1 if msa_num == 1

generate msa_bal = 0
replace msa_bal = 1 if msa_num == 2

generate msa_chi = 0
replace msa_chi = 1 if msa_num == 3

generate msa_los = 0
replace msa_los = 1 if msa_num == 4

generate msa_mia = 0
replace msa_mia = 1 if msa_num == 5

generate msa_min = 0
replace msa_min = 1 if msa_num == 6

generate msa_new = 0
replace msa_new = 1 if msa_num == 7

generate msa_pho = 0
replace msa_pho = 1 if msa_num == 8

generate msa_pit = 0
replace msa_pit = 1 if msa_num == 9

generate msa_san = 0
replace msa_san = 1 if msa_num == 10



*** Generate a new numeric index for LOAN_ID ***
************************************************

drop loan_id_num
egen big_loan_num = group(loan_id)



save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 both_purch_frm generated_50.dta", replace



log close

clear



