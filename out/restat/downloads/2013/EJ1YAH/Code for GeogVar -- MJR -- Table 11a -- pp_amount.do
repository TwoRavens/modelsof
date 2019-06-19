*** NOTE:  This do-file performs the specifications in Table 11a with APL = pp_amount ***



program mymlogit_uh_lf
	version 10.1
	args lnf bxj1 bxj2 loc_j1_l1 loc_j1_l2 mass_point loc_j2_l1 loc_j2_l2
	tempvar denom_l1 denom_l2 mass_prob_l1 mass_prob_l2
	quietly generate double `denom_l1' = 1 + exp(`bxj1' + `loc_j1_l1') + exp(`bxj2' + `loc_j2_l1')
	quietly generate double `denom_l2' = 1 + exp(`bxj1' + `loc_j1_l2') + exp(`bxj2' + `loc_j2_l2')

	quietly generate double `mass_prob_l1' = exp(`mass_point') / (1 + exp(`mass_point'))
	quietly generate double `mass_prob_l2' = 1 / (1 + exp(`mass_point'))


	quietly replace `lnf' = ln((`mass_prob_l1'*(1/`denom_l1')) + (`mass_prob_l2'*(1/`denom_l2'))) if $ML_y1 == 0
	quietly replace `lnf' = ln((`mass_prob_l1'*(exp(`bxj1' + `loc_j1_l1')/`denom_l1')) + (`mass_prob_l2'*(exp(`bxj1' + `loc_j1_l2')/`denom_l2'))) if $ML_y1 == 1
	quietly replace `lnf' = ln((`mass_prob_l1'*(exp(`bxj2' + `loc_j2_l1')/`denom_l1')) + (`mass_prob_l2'*(exp(`bxj2' + `loc_j2_l2')/`denom_l2'))) if $ML_y1 == 2
end



log using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Logs\20110231 APL regs -- original size -- purch_frm -- pp_amount.log", replace



***********************
***********************
*** APL regressions ***
*** purch_frm       ***
*** pp_amount       ***
***********************
***********************



use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\apl law variables for stata.dta", clear
sort origmonth state
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\apl law variables for stata.dta", replace

use "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\all10 50 size both purch_frm generated.dta", clear
keep if outsample_a != 1 & fico > 0 & cltv != 0 & balance != 0
compress
sort origmonth state
save "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\All 10 MSAs\TEMP all10 50 size both purch_frm generated.dta", replace
merge origmonth state using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Data\apl law variables for stata.dta"

egen big_loan_num = group(loan_id)

drop loan_id pp_pen pp_term state mba_stat currmonth origmonth mba_stat_lead1 outcome_b outsample_b outcome_c hpa init_rate orig_risk_prem subprime loan_id_num flip_loantype anti_steering

replace pp_amount = 0 if cover_purch == 0

generate apl_pre = pp_amount * prepay_pen
generate apl_pre_end = pp_amount * prepay_pen_end
*generate apl_bal = pp_amount * balloon
*generate apl_doc = pp_amount * lownodoc
compress

generate msa_atl = 0
generate msa_bal = 0
generate msa_chi = 0
generate msa_los = 0
generate msa_mia = 0
generate msa_min = 0
generate msa_new = 0
generate msa_pho = 0
generate msa_pit = 0
generate msa_san = 0
replace msa_atl = 1 if msa_num == 1
replace msa_bal = 1 if msa_num == 2
replace msa_chi = 1 if msa_num == 3
replace msa_los = 1 if msa_num == 4
replace msa_mia = 1 if msa_num == 5
replace msa_min = 1 if msa_num == 6
replace msa_new = 1 if msa_num == 7
replace msa_pho = 1 if msa_num == 8
replace msa_pit = 1 if msa_num == 9
replace msa_san = 1 if msa_num == 10
compress

generate pre_atl = prepay_pen * msa_atl
generate pre_bal = prepay_pen * msa_bal
generate pre_chi = prepay_pen * msa_chi
generate pre_los = prepay_pen * msa_los
generate pre_mia = prepay_pen * msa_mia
generate pre_min = prepay_pen * msa_min
generate pre_new = prepay_pen * msa_new
generate pre_pho = prepay_pen * msa_pho
generate pre_pit = prepay_pen * msa_pit
generate pre_san = prepay_pen * msa_san
compress

generate pre_end_atl = prepay_pen_end * msa_atl
generate pre_end_bal = prepay_pen_end * msa_bal
generate pre_end_chi = prepay_pen_end * msa_chi
generate pre_end_los = prepay_pen_end * msa_los
generate pre_end_mia = prepay_pen_end * msa_mia
generate pre_end_min = prepay_pen_end * msa_min
generate pre_end_new = prepay_pen_end * msa_new
generate pre_end_pho = prepay_pen_end * msa_pho
generate pre_end_pit = prepay_pen_end * msa_pit
generate pre_end_san = prepay_pen_end * msa_san
compress

generate bal_atl = balloon * msa_atl
generate bal_bal = balloon * msa_bal
generate bal_chi = balloon * msa_chi
generate bal_los = balloon * msa_los
generate bal_mia = balloon * msa_mia
generate bal_min = balloon * msa_min
generate bal_new = balloon * msa_new
generate bal_pho = balloon * msa_pho
generate bal_pit = balloon * msa_pit
generate bal_san = balloon * msa_san
compress

generate doc_atl = lownodoc * msa_atl
generate doc_bal = lownodoc * msa_bal
generate doc_chi = lownodoc * msa_chi
generate doc_los = lownodoc * msa_los
generate doc_mia = lownodoc * msa_mia
generate doc_min = lownodoc * msa_min
generate doc_new = lownodoc * msa_new
generate doc_pho = lownodoc * msa_pho
generate doc_pit = lownodoc * msa_pit
generate doc_san = lownodoc * msa_san
compress



*************************
*** APL variable only ***
*************************

*** Generating matrix of starting values using values from regression without APL variables ***
matrix starter = (0,0.1317806,0.3935601,0.8051443,0.6903732,-0.0099589,0.0393597,7.585278,0.1280882,-0.0015055,0.3307486,0.0519243,0.0010815,-0.4869193,0.1660156,0.2508163,0.5741095,0.9866274,-0.6399832,0.0595036,0.3024132,1.169474,1.420519,0.1089778,0.718664,0.2249721,-0.4315511,-0.9743662,-0.2520485,0.267645,-0.5400864,-0.4755918,-0.0459952,0.1475213,-0.7544485,-0.5430176,-0.6124764,-0.8147868,-0.2312822,-1.01173,-0.3000394,0.8824044,0.3281924,-0.5976241,-0.7234403,0.1423815,-0.825661,-1.104558,-1.292228,0.2043952,-1.055531,-0.577622,0.1941669,-0.6651291,-1.182829,-0.0135212,-0.1611356,-0.2568338,-0.6080042,-0.1656901,-0.0954143,-0.2501722,0.0886609,-0.5227319,0,-0.472951,0.5939633,-0.2324729,-0.0342984,0.0001278,-0.0078403,4.541875,0.0653193,-0.0014343,0.0829679,-0.1089037,0.0171673,0.1985079,-0.1507457,-0.3900361,-0.7888253,-1.001074,-0.2306064,-0.4252686,0.2029316,0.1293574,-0.3714801,-0.1686743,-0.2719826,0.1557363,-0.3807299,-0.8506201,-0.2809469,0.113443,-0.9073942,-0.1015761,0.1118667,-0.5106542,-0.3829174,-0.4856202,-0.7310608,-0.2005895,-0.2178661,-0.1058447,-0.0258198,0.4177285,0.0329988,0.0675084,-0.439047,-0.3656482,0.2985091,-0.3032679,-0.0337341,-0.3326788,0.0339081,0.3022608,0.0937636,-0.4563317,-0.2751711,0.1192199,0.0446025,0.4111282,0.1373686,0.198679,0.2597567,-0.1085987,0.1998267,0.0305104,-9.529863,-1.770993,3.449273,-4.847018,-1.438022)

*** Running mymlogit_uh_lf ***
ml model lf mymlogit_uh_lf (default: outcome_a = pp_amount prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (payoff: pp_amount prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (default_const1:) (default_const2:) (prob_coeff1:) (payoff_const1:) (payoff_const2:) if outsample_a != 1 & fico > 0 & cltv != 0 & balance != 0, cluster(big_loan_num)
*ml check
ml init starter, copy
ml maximize, iterate(50) difficult
outreg2 using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic consistency\Stata\Stata Outregs\20110231 APL regs original size purch_frm pp_amount.txt", replace onecol text bracket(se) e(all)
*ml graph
do "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Do-files\mymlogit_uh_lf\Wald tests -- MSA-PLP interactions -- FRMs.do"

*** Saving the matrix of coefficient estimates ***
matrix a = e(b)

*** Creating starter matrices with 0 values for the APL*PLP interaction term coefficient estimates ***
*** -- This uses e(df_m), which is the number of explanatory variables in each equation, not       ***
***    including constant terms.                                                                   ***
*** -- For prepay_pen regressions, the APL variable is interacted with both prepay_pen and         ***
***    prepay_pen_end, requiring an extra pair of APL*PLP interaction term coefficient estimates.  ***
matrix afirst = a[1,1]
matrix asecond = a[1,2..(e(df_m)+1)]
matrix athird = a[1,(e(df_m)+2)..((e(df_m)*2)+5)]
matrix starter1 = (afirst,0,0,asecond,0,0,athird)
*matrix starter2 = (afirst,0,asecond,0,athird)



*********************************************
*** APL*prepay_pen and APL*prepay_pen_end ***
*********************************************

*** Running mymlogit_uh_lf ***
ml model lf mymlogit_uh_lf (default: outcome_a = pp_amount apl_pre apl_pre_end prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (payoff: pp_amount apl_pre apl_pre_end prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (default_const1:) (default_const2:) (prob_coeff1:) (payoff_const1:) (payoff_const2:) if outsample_a != 1 & fico > 0 & cltv != 0 & balance != 0, cluster(big_loan_num)
*ml check
ml init starter1, copy
ml maximize, iterate(50) difficult
outreg2 using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic consistency\Stata\Stata Outregs\20110231 APL regs original size purch_frm pp_amount.txt", append onecol text bracket(se) e(all)
*ml graph
do "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Do-files\mymlogit_uh_lf\Wald tests -- MSA-PLP interactions -- FRMs.do"

/*

*******************
*** APL*balloon ***
*******************

*** Running mymlogit_uh_lf ***
ml model lf mymlogit_uh_lf (default: outcome_a = pp_amount apl_bal prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (payoff: pp_amount apl_bal prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (default_const1:) (default_const2:) (prob_coeff1:) (payoff_const1:) (payoff_const2:) if outsample_a != 1 & fico > 0 & cltv != 0 & balance != 0, cluster(big_loan_num)
*ml check
ml init starter2, copy
ml maximize, iterate(50) difficult
outreg2 using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic consistency\Stata\Stata Outregs\20110231 APL regs original size purch_frm pp_amount.txt", append onecol text bracket(se) e(all)
*ml graph
do "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Do-files\mymlogit_uh_lf\Wald tests -- MSA-PLP interactions -- FRMs.do"



********************
*** APL*lownodoc ***
********************

*** Running mymlogit_uh_lf ***
ml model lf mymlogit_uh_lf (default: outcome_a = pp_amount apl_doc prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (payoff: pp_amount apl_doc prepay_pen prepay_pen_end balloon lownodoc fico cltv refi_premium ageofloan ageofloan_2 rel_loan_size chg_unempl var_hpi var_fixed vint2003 vint2004 vint2005 vint2006 judicial msa_atl msa_bal msa_chi msa_mia msa_min msa_new msa_pho msa_pit msa_san pre_atl pre_bal pre_chi pre_mia pre_min pre_new pre_pho pre_pit pre_san pre_end_atl pre_end_bal pre_end_chi pre_end_mia pre_end_min pre_end_new pre_end_pho pre_end_pit pre_end_san bal_atl bal_bal bal_chi bal_mia bal_min bal_new bal_pho bal_pit bal_san doc_atl doc_bal doc_chi doc_mia doc_min doc_new doc_pho doc_pit doc_san, noconstant) (default_const1:) (default_const2:) (prob_coeff1:) (payoff_const1:) (payoff_const2:) if outsample_a != 1 & fico > 0 & cltv != 0 & balance != 0, cluster(big_loan_num)
*ml check
ml init starter2, copy
ml maximize, iterate(50) difficult
outreg2 using "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic consistency\Stata\Stata Outregs\20110231 APL regs original size purch_frm pp_amount.txt", append onecol text bracket(se) e(all)
*ml graph
do "C:\Documents and Settings\morgan.rose\My Documents\Foreclosure\Geographic Consistency\Stata\Stata Do-files\mymlogit_uh_lf\Wald tests -- MSA-PLP interactions -- FRMs.do"

*/

log close



program drop mymlogit_uh_lf



clear



