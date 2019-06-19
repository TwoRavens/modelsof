version 10
set more off
clear matrix
clear
capture log close
set mem 700m

***NOTE: INDREG_OCT2010.DO CREATES THE FILE INDREG_FILEREADY_OCT2010.DTA, BUT IT HAS LOTS OF EXTRA VARIABLES, SO CREATE AGAIN KEEPING ONLY REQUIRED VARS + ANONYMIZING BUREAUCRAT IDENTITY

*********************************************************************
******TABLE 1: SUMMARY STATISTICS
*********************************************************************
use table2.dta, clear
summ year_allot gendum homestate1 orank10 orank20 orank30 wks_training wks_foreign empanel_dum if year==2004 & base==1
summ transdum scolldum simp1ias trtype1dum2 trtype1dum3 if transdum~=. & base==1

***means for District Officer transfers later (in table 7 section)

****means for Table 1, panel C
use table2.dta, clear
duplicates drop cadre_code year, force
**dropping split states before the year of their existence
drop if cadre=="JHARKHAND" & year<2000
drop if cadre=="CHHATTISGARH" & year<2000
drop if cadre=="UTTARANCHAL" & year<2000
summ cmchange cmpartychange selecdum gelecdum

*********************************************************************
*******TABLE 2: POLITICAL CHANGE AND BUREAUCRAT TURNOVER
*********************************************************************
use table2.dta, clear
xi i.year

*column 1: cmchange effect
areg transdum cmchange _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmchange using table2.out, replace se coef 3aster

*column 2: controlling for elections and years of experience quadratic
areg transdum cmchange selecdum gelecdum year_exp year_exp_sq  _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmchange selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster

*column 3: controlling for elections and years of experience quadratic + GDP and crime: 	TO BE DONE (CRIME/SDP DATA TO BE MERGED)
areg transdum cmchange selecdum gelecdum year_exp year_exp_sq  crime_pop riot_pop gsdpcons_unsplitsc _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmchange selecdum gelecdum year_exp year_exp_sq  crime_pop riot_pop gsdpcons_unsplitsc using table2.out, append se coef 3aster

*column 4: CM change with and without party change
areg transdum cmpartychange cmnopartychange selecdum gelecdum year_exp year_exp_sq  _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmpartychange cmnopartychange selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster
test cmpartychange=cmnopartychange

*column 5: CM change with and without elections
areg transdum cmelec cmnoelec selecdum gelecdum year_exp year_exp_sq  _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmelec cmnoelec selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster
test cmelec=cmnoelec 

*column 6: transfer with promotion
areg trans_promo cmchange selecdum gelecdum year_exp year_exp_sq  _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmchange selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster

*column 7: lateral transfer
areg trans_lat cmchange selecdum gelecdum year_exp year_exp_sq  _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmchange selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster

**column 8: robustness 1, drop cohorts <=1979
areg transdum cmchange selecdum gelecdum year_exp year_exp_sq  _Iyear* if base==1 & year_allot>=1979,  absorb (identifier) cluster(cadre_code)
outreg cmchange selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster

***column 9: robustness 2: include SCS officers <=2000
areg transdum cmchange selecdum gelecdum year_exp year_exp_sq  _Iyear* if year_allot<=2000,  absorb (identifier) cluster(cadre_code)
outreg cmchange selecdum gelecdum year_exp year_exp_sq  using table2.out, append se coef 3aster


*********************************************************************
******TABLE 3: ARE ABLE OFFICERS LESS LIKELY TO BE TRANSFERRED
*********************************************************************
reg transdum cmchange
outreg cmchange using table3.out, replace se coef 3aster title("Table 3 results, ignore first column")

***columns 1-3
foreach var of varlist orank10 orank20 orank30 {
areg transdum cm_`var' cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 ,  absorb (identifier) cluster(cadre_code)
outreg cm_`var' cmchange cmchange_home using table3.out, append se coef 3aster
}

/**col 4: controlling for gender and experience***/
areg transdum cm_orank20 year_exp year_exp_sq  cmchange selecdum gelecdum cmchange_gen cmchange_exp cmchange_home _Iyear* if base==1 ,  absorb (identifier) cluster(cadre_code)
outreg cm_orank20 cmchange cmchange_gen cmchange_exp cmchange_home using table3.out, append se coef 3aster

/***col 5: sample of men only***/
areg transdum cm_orank20 cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 & gendum==0 ,  absorb (identifier) cluster(cadre_code)
outreg cm_orank20 cmchange cmchange_home using table3.out, append se coef 3aster

/***col 6: exclude cohorts earlier than 1979, men only***/
areg transdum cm_orank20   cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 & year_allot>=1979 & gendum==0,  absorb (identifier) cluster(cadre_code)
outreg cm_orank20 cmchange cmchange_home using table3.out, append se coef 3aster

/***col 7: percentile ranks, men only****/
areg transdum cm_oprank20 cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 & gendum==0,  absorb (identifier) cluster(cadre_code)
outreg cm_oprank20 cmchange cmchange_home using table3.out, append se coef 3aster

/***col 8: logit specification, men only****/
logit transdum cm_orank20 year_exp year_exp_sq  cmchange selecdum gelecdum cmchange_home homestate1 orank20 _Iyear* if base==1 & gendum==0 ,  vce(cluster cadre_code)
outreg cm_orank20 cmchange cmchange_home using table3.out, append se coef 3aster


*********************************************************************
******TABLE 4: DO ABLE BUREAUCRATS HAVE LESS VARIATION IN JOB QUALITY
*********************************************************************
reg trtype1dum3 cm_orank20 
outreg cm_orank20 using table4.out, replace se coef 3aster title("table 4 results, ignore first column")

***col 1-3
foreach rankvar of varlist orank10 orank20 orank30 {
areg trtype1dum3 cm_`rankvar' cmchange selecdum gelecdum cmchange_home _Iyear* if base==1,  absorb (identifier) cluster(cadre_code)
outreg cmchange cm_`rankvar' cmchange_home using table4.out, append se coef 3aster
}

/***col 4: controlling for gender and experience***/
areg trtype1dum3 year_exp year_exp_sq  cm_orank20 cmchange selecdum gelecdum cmchange_gen cmchange_exp cmchange_home _Iyear* if base==1 ,  absorb (identifier) cluster(cadre_code)
outreg cmchange cm_orank20 cmchange_gen cmchange_exp cmchange_home using table4.out, append se coef 3aster

/***col 5: men only****/
areg trtype1dum3 cm_orank20 cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 & gendum==0 ,  absorb (identifier) cluster(cadre_code)
outreg cmchange cm_orank20 cmchange_home using table4.out, append se coef 3aster

/***col 6: exclude cohorts ealier than 1979, men only***/
areg trtype1dum3 cm_orank20 cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 & year_allot>=1979 & gendum==0,  absorb (identifier) cluster(cadre_code)
outreg cmchange cm_orank20 cmchange_home using table4.out, append se coef 3aster

/****col 7: percentile ranks***/
areg trtype1dum3 cm_oprank20 cmchange selecdum gelecdum cmchange_home _Iyear* if base==1 & gendum==0 ,  absorb (identifier) cluster(cadre_code)
outreg cmchange cm_oprank20 cmchange_home  using table4.out, append se coef 3aster

/***col 8: logit specification****/
logit trtype1dum3 cmchange selecdum gelecdum gendum homestate1 orank20 cm_orank20 cmchange_home year_exp year_exp_sq _Iyear* if base==1 & gendum==0,  vce(cluster cadre_code)
outreg cmchange cm_orank20 cmchange_home using table4.out, append se coef 3aster

*********************************************************************
******TABLE 5: INITIAL ABILITY AND INVESTMENTS IN EXPERTISE
*********************************************************************
/*****TABLE 5 nov 2009: BUREAUCRAT CAREER PROGRESSION, robustness to ranks****/

xi i.year_allot 

regress wks_training orank10
outreg orank10 using table5.out, replace se coefastr 3aster title("Table 5 results, ignore first column")

foreach var of varlist wks_training  wks_foreign {
foreach x of varlist orank10 orank20 orank30 {
reg `var' `x' gendum homestate1 _Iyear_all* if year==2004 & base==1, cluster(cadre_code)
outreg `x' gendum homestate1 using table5.out, append se coefastr 3aster
}
}

*********************************************************************
******TABLE 6: ROLE OF SKILL AND CASTE LOYALTY
*********************************************************************

regress empanel_dum orank20
outreg orank20 using table6.out, replace se coefastr 3aster title("Table 6 results, ignore first column")

****col 1-2
foreach x of varlist orank20 orank30 {
reg empanel_dum `x' gendum homestate1 _Iyear_all* if year==2004 & base==1, cluster(cadre_code)
outreg `x' gendum homestate1 using table6.out, append se coefastr 3aster
}

****col 3, control for weeks of foreign training
reg empanel_dum wks_foreign orank20 gendum homestate1 _Iyear_all* if year==2004 & base==1, cluster(cadre_code)
outreg wks_foreign orank20 gendum homestate1 using table6.out, append se coefastr 3aster

****col 6 & 7
foreach x of varlist orank20 orank30 {
reg meanimp1 `x' gendum homestate1 _Iyear_all* if year==2004 & base==1, cluster(cadre_code)
outreg `x' gendum homestate1 using table6.out, append se coefastr 3aster
}


****col 4 & 5
use table6_caste.dta, clear
xi i.year 
areg simp1ias year_exp year_exp_sq  cmoffsamecaste2 cmchange cm_orank20 cmchange_gen cmchange_exp cmchange_home selecdum gelecdum _Iyear* if directdum==1 & year_allot<=2000& year>=1990,  absorb (identifier) 
outreg cmoffsamecaste2 cmchange cm_orank20 using table6.out, append se coef 3aster

areg simp1ias year_exp year_exp_sq  cmoffsamecaste2 cmchange cm_orank30 cmchange_gen cmchange_exp cmchange_home selecdum gelecdum _Iyear* if directdum==1 & year_allot<=2000& year>=1990,  absorb (identifier) 
outreg cmoffsamecaste2 cmchange cm_orank30 using table6.out, append se coef 3aster



*********************************************************************
******TABLE 7: ROLE OF LOCAL POLITICIANS
*********************************************************************
use table7.dta, clear

***col 1
areg transdum cmchange selecdum gelecdum _Iyear* if year>=1985, absorb(dist1988) cluster(state)
outreg cmchange using table7.out, replace se coef 3aster title("Table 7: role of local politicians")

***col 2
areg transdum cmchange MLA_CM_sameparty newcm_mlacm_sameparty selecdum gelecdum _Iyear* if year>=1985, absorb(dist1988) cluster(state)
outreg cmchange MLA_CM_sameparty newcm_mlacm_sameparty using table7.out, append se coef 3aster
test cmchange + newcm_mlacm_sameparty=0

***col 3
areg transdum cmpartychange cmnopartychange MLA_CM_sameparty cmparty_mlacm cmnoparty_mlacm selecdum gelecdum _Iyear* if year>=1985, absorb(dist1988) cluster(state)
outreg cmpartychange cmnopartychange MLA_CM_sameparty cmparty_mlacm cmnoparty_mlacm using table7.out, append se coef 3aster
test cmpartychange + cmparty_mlacm =0
test cmnopartychange + cmnoparty_mlacm =0
test cmpartychange=cmnopartychange
test cmparty_mlacm = cmnoparty_mlacm 

***col 4
areg transdum cmchange newcm_polturn pol_turn selecdum gelecdum _Iyear* if year>=1985, absorb(dist1988) cluster(state)
outreg cmchange newcm_polturn pol_turn using table7.out, append se coef 3aster


***means for table 1
summ transdum if year>=1985
 
*********************************************************************
******TABLE 8: BUREAUCRAT TRANSFERS AND DISTRICT OUTCOMES
*********************************************************************
***col 1
use table8a.dta, clear
xi i.state 
reg complete_immunizations trans_cmchange_95 trans_nocmchange_95  _Istate_* if year==2001, cluster(state)
outreg  trans_cmchange_95 trans_nocmchange_95 using table8.out, replace se coef 3aster title("Table 8 results")

***col 2 and 3
use table8b.dta, clear
xi i.year i.statenum

regress roadcompletedum trans_cmchange_04 trans_nocmchange_04 _Istatenum* if year== 2000, cluster(statenum)
outreg trans_cmchange_04 trans_nocmchange_04 using table8.out, append se coefastr 3aster
test trans_cmchange_04=trans_nocmchange_04

regress roadcompletedum trans_cmchange_04 trans_nocmchange_04 _Istatenum* if year== 2003, cluster(statenum)
outreg trans_cmchange_04 trans_nocmchange_04 using table8.out, append se coefastr 3aster
test trans_cmchange_04=trans_nocmchange_04


***col 4 and 5
use table8c.dta, clear
xi i.uscc 

reg povrate_change_allyrs trans_cmchange_allyrs trans_nocmchange_allyrs inpov1987 _Iuscc_* if year==1999 & check~=., cluster(uscc)
outreg trans_cmchange_allyrs trans_nocmchange_allyrs inpov1987 using table8.out, append se coef 3aster
test trans_cmchange_allyrs= trans_nocmchange_allyrs 

reg povrate_change_1999 trans_cmchange_99 trans_nocmchange_99 inpov1993 _Iuscc_* if year==1999 & check~=., cluster(uscc)
outreg trans_cmchange_99 trans_nocmchange_99 inpov1993 using table8.out, append se coef 3aster
test trans_cmchange_99= trans_nocmchange_99 





