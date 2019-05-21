***************************************************************************
* File:               main_results_aggregate_data.do
* Author:             Miguel R. Rueda
* Description:        Aggregate level results reported in paper and supplemental material that use Stata.
* Created:            Aug - 22 - 2015
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small Aggregates..."
***************************************************************************


clear

use final_aggregate.dta, clear

*Declaring panel
tsset muni_code year, yearly

*Figure 1
cibplot VB_pc , by(pob_mesa_q) baropt( plotregion(margin(b = 0))) ytitle(Number of reports per 1000 people) xtitle(Polling place size)

*Table 1 (without stats on LAPOP) and Table 3 (appendix) 
quietly: nbreg e_vote_buying l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code) 
summ e_vote_buying sum_vb pot_mesa l4.pob_mesa if e(sample)
summ e_vote_buying sum_vb neg_t_buying_moe l4.pob_mesa l.armed_actor closeness_CG l4.size l4.margin_index2 l.own_resources l4.margin_index2 l.nbi_i population if e(sample)

* Stats on LAPOP are given by main_results_LAPOP.do

*Table 2 (appendix)
tabstat sum_vb e_vote_buying if e(sample), s(mean sd min max) by(year)

*Table 2 
*2008 and 2009 are taken out as there are only atypical elections in those years
nbreg e_vote_buying l4.lpob_mesa lpopulation if year!=2008&year!=2009, cluster(muni_code) 
nbreg e_vote_buying lpot_mesa lpopulation if e(sample), cluster(muni_code) 
nbreg e_vote_buying l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if e(sample), cluster(muni_code) 

*Table 3 (without multiple imputation results)
nbreg sum_vb L4.lpob_mesa lpopulation if year!=2008&year!=2009, cluster(muni_code) 
nbreg sum_vb l4.margin_index2 l.nbi_i L4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code) 
xtpoisson sum_vb l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, difficult fe
*xtreg sum_vb l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if e(sample), cluster(muni_code)  fe
xtreg sum_vb l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code)  fe

*For Multiple Imputation results of Table 3 run MI_Table3_aggregate_results.do and results will be in data editor

*Table 5
quietly: nbreg e_vote_buying l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code) 
ivreg2 e_vote_buying lpopulation lpotencial (lm_pob_mesa = lz_pob_mesa_f) if e(sample), first cluster(muni_code)
ivreg2 e_vote_buying lpopulation potencial potencial_sq potencial_cu (lm_pob_mesa = lz_pob_mesa_f) if e(sample), first cluster(muni_code)
*ivreg2 e_vote_buying lpopulation ltrend_f (lm_pob_mesa = lz_pob_mesa_f)if e(sample), first cluster(muni_code)
ivreg2 e_vote_buying l4.margin_index2 l.nbi_i l.own_resources lpopulation l.armed_actor l4.lsize lpotencial (lm_pob_mesa = lz_pob_mesa_f) if e(sample), first cluster(muni_code)
ivreg2 e_vote_buying l4.margin_index2 l.nbi_i l.own_resources lpopulation l.armed_actor l4.lsize lpotencial (lm_pob_mesa = lz_pob_mesa_f) if discont_f==1&e(sample), first cluster(muni_code)
*ivreg2 e_vote_buying lpopulation lpotencial (lm_pob_mesa = lz_pob_mesa_f) if discont_f==1&e(sample), first cluster(muni_code)


quietly: nbreg e_vote_buying l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code) 
ivreg2 sum_vb lpopulation lpotencial (lm_pob_mesa = lz_pob_mesa_f) if e(sample), first cluster(muni_code)
ivreg2 sum_vb lpopulation potencial potencial_sq potencial_cu (lm_pob_mesa = lz_pob_mesa_f) if e(sample), first cluster(muni_code)
ivreg2 sum_vb l4.margin_index2 l.nbi_i l.own_resources lpopulation l.armed_actor l4.lsize lpotencial (lm_pob_mesa = lz_pob_mesa_f) if e(sample), first cluster(muni_code)
ivreg2 sum_vb l4.margin_index2 l.nbi_i l.own_resources lpopulation l.armed_actor l4.lsize lpotencial (lm_pob_mesa = lz_pob_mesa_f) if discont_f==1&e(sample), first cluster(muni_code)


*Table 6 (without LAPOP results)
quietly: nbreg e_neg_t_buying l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code) 
nbreg e_neg_t_buying l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if e(sample), cluster(muni_code) 
quietly: nbreg neg_t_buying_moe l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if year!=2008&year!=2009, cluster(muni_code) 
nbreg neg_t_buying_moe l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if e(sample), cluster(muni_code) 
xtreg neg_t_buying_moe l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if e(sample),  fe  cluster(muni_code) 
xtlogit neg_t_buying_moe l4.margin_index2 l.nbi_i l4.lpob_mesa l.own_resources lpopulation l.armed_actor l4.lsize if e(sample), difficult fe


*Figure 2
twoway (line z_pob_mesa_f potencial if potencial<5000&year==2007, sort legend(off)) (line m_pob_mesa potencial if potencial<5000&year==2007, sort)

*Figure 1 (appendix)
twoway (line z_pob_mesa_f potencial if potencial<5000&year==2010, sort legend(off)) (line m_pob_mesa potencial if potencial<5000&year==2010, sort)

replace lnbi=L.nbi_i 

*Table 8 (appendix without LAPOP)
sureg (e_vote_buying l4margin_index2 lnbi l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize) (e_neg_t_buying l4margin_index2 lnbi l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize) if year!=2008&year!=2009
test [e_neg_t_buying]l4lpob_mesa=[e_vote_buying]l4lpob_mesa
quietly: regress e_vote_buying l4margin_index2 if e(sample), cluster(muni_code) 
*Number of municipalities
display e(N_clust)

sureg (sum_vb l4margin_index2 llnbi_i l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize) (neg_t_buying_moe l4margin_index2 lnbi_i l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize) if year!=2008&year!=2009
test [neg_t_buying_moe]l4lpob_mesa=[sum_vb]l4lpob_mesa
quietly: regress e_vote_buying l4margin_index2 if e(sample), cluster(muni_code) 
*Number of municipalities
display e(N_clust)




