* 06 SEPTEMBER 2005
* REPLICATION FILE FOR "OPENNESS, UNCERTAINTY, AND SOCIAL SPENDING: IMPLICATIONS FOR THE GLOBALIZATION-WELFARE STATE DEBATE"
* by Irfan Nooruddin and Joel Simmons

******************************
*/ dumlag dumld pol3lag pol3ld pollag polld educlag educld welflag welfld lngdpcapld lngdpcaplag /*
*/ dependld dependlag  /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld if oecd==0

******************************
quietly xi3:  xtpcse educ_change importld*importlag*dumlag educlag educld lngdpcapld lngdpcaplag /*
*/ dependld dependlag dumld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 if oecd==0, pa
quietly xi3:  xtpcse welfg_change importld*importlag*dumlag welfglag welfgld lngdpcapld lngdpcaplag /*
*/ dependld dependlag dumld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 if oecd==0, pa

estimates restore base_educ
tab ctryname if e(sample)
estimates restore base_welfg
tab ctryname if e(sample)


******************************
*/ dependld dependlag dumld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 if oecd==0, pa
quietly xi3:  xtpcse welfg_change importld*importlag*dumlag welfglag welfgld lngdpcapld lngdpcaplag /*
*/ dependld dependlag dumld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 if oecd==0, pa

estimates table base_welfg base_educ base_educ , /*
 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N ll aic bic) /*
 */ keep(welfglag welfgld educlag educld importld importlag dumlag _IimXim _IimXdu _I1imXdu _IimXimXdu /*
 */  exportgdplag exportgdpld lngdpcapld /*
 */ lngdpcaplag dependld dependlag dumld bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld /*
 */ log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

******************************
****************************** FIGURE 6: MARGINAL EFFECT GRAPH FOR WELFARE (% TOTAL SPENDING)
******************************
estimates restore base_welfg


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

******************************
****************************** FIGURE 7: MARGINAL EFFECT GRAPH FOR EDUCATION (% TOTAL SPENDING)
******************************
estimates restore base_educ


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt



******************************
******************************TABLE 3 & FOOTNOTE 22: DVs MEASURED INSTEAD AS SHARE OF GDP******
******************************
xi3:  xtpcse educgdp_change importld*importlag*dumlag educgdplag educgdpld lngdpcapld lngdpcaplag /*
*/ dependld dependlag dumld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 if oecd==0, pa
estimates restore educ_gdp


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

*/ dependld dependlag dumld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 if oecd==0, pa


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt


 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N ll aic bic) /*
 */ keep(importld importlag dumlag _IimXim _IimXdu _I1imXdu _IimXimXdu /*
 */ educgdplag educgdpld welflag welfld exportgdplag exportgdpld lngdpcapld /*
 */ lngdpcaplag dependld dependlag dumld bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

******************************
******************************FOOTNOTE 24: TOTAL TRADE INSTEAD OF IMPORTS
*/ dependld dependlag dumld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates store educ_trade_dum
estimates restore educ_trade_dum


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

xi3:  xtpcse welfg_change tradeld*tradelag*dumlag welfglag welfgld  lngdpcapld lngdpcaplag dependld /*
*/ dependld dependlag dumld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates store welfg_trade_dum
estimates restore welfg_trade_dum


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N ll aic bic) /*
 */ keep(tradeld tradelag dumlag _ItrXtr _ItrXdu _I1trXdu _ItrXtrXdu /*
 */ educlag educld welfglag welfgld lngdpcapld /*
 */ lngdpcaplag dependld dependlag dumld bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

******************************
******************************FOOTNOTE 25: SPLIT SAMPLE INSTEAD OF TRIPLE INTERACTIONS******
******************************
reg educ_change importld importlag importldXimportlag educlag educld lngdpcapld lngdpcaplag /*
*/ dependld dependlag exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 /*
*/ if oecd==0&dumlag==0, cluster(ctrycode)
estimates restore educ_nondems
#delimit ;
drop MV conb conse a upper lower;

reg educ_change importld importlag importldXimportlag educlag educld lngdpcapld lngdpcaplag /*
*/ dependld dependlag exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 /*
*/ if oecd==0&dumlag==1, cluster(ctrycode)
estimates restore educ_dems
#delimit ;
drop MV conb conse a upper lower;

reg welfg_change importld importlag importldXimportlag welfglag welfgld lngdpcapld lngdpcaplag /*
*/ dependld dependlag exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 /*
*/ if oecd==0&dumlag==0, cluster(ctrycode)
estimates restore welfg_nondems
#delimit ;
drop MV conb conse a upper lower;

reg welfg_change importld importlag importldXimportlag welfglag welfgld lngdpcapld lngdpcaplag /*
*/ dependld dependlag exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year f1-f215 /*
*/ if oecd==0&dumlag==1, cluster(ctrycode)
estimates restore welfg_dems
#delimit ;
drop MV conb conse a upper lower;

estimates table educ_nondems educ_dems welfg_nondems welfg_dems , /*
 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N) /*
 */ keep(importld importlag importldXimportlag /*
 */ educlag educld welfglag welfgld exportgdplag exportgdpld lngdpcapld /*
 */ lngdpcaplag dependld dependlag bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld /*
 */ log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

******************************
******************************TABLE 3: SENSITIVITY ANALYSIS
******************************
set more off
*/ dependld dependlag polld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates restore educ_polity2


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt


*/ dependld dependlag polld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates restore welfg_polity2


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

estimates table educ_polity2 welfg_polity2 , /*
 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N ll aic bic) /*
 */ keep(importld importlag pollag _IimXim _IimXpo _I1imXpo _IimXimXpo /*
 */ educlag educld welfglag welfgld exportgdplag exportgdpld lngdpcapld /*
 */ lngdpcaplag dependld dependlag polld bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld /*
 */ log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

******************************
*****************************FOOTNOTE 31: USING TRICHOTOMOUS CODING OF POLITY******
******************************
set more off
*/ dependld dependlag pol3ld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates restore educ_pol3


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

xi3:  xtpcse welfg_change importld*importlag*pol3lag welfglag welfgld lngdpcapld lngdpcaplag /*
*/ dependld dependlag pol3ld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates restore welfg_pol3


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt

estimates table educ_pol3 welfg_pol3 , /*
 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N ll aic bic) /*
 */ keep(importld importlag pol3lag _IimXim _IimXpo _I1imXpo _IimXimXpo /*
 */ educlag educld welfglag welfgld exportgdplag exportgdpld lngdpcapld /*
 */ lngdpcaplag dependld dependlag pol3ld bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld /*
 */ log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

******************************
******************************ROBUSTNESS: FLIPPING THE DICHOTMOUS POLITY SCALE SO THAT DICTATORSHIPS == 1******
******************************
set more off
*/ dependld dependlag polity_di_revld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates restore educ_poldirev


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt


xi3:  xtpcse welfg_change importld*importlag*pdirvlag welfglag welfgld lngdpcapld lngdpcaplag /*
*/ dependld dependlag polity_di_revld exportgdplag exportgdpld /*
*/ bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld  log_dt_dod_dect_cdlag log_dt_dod_dect_cdld   year f1-f215 if oecd==0, pa
estimates restore welfg_poldirev


*/  legend(off)

drop  MV conb0 conb1 conb2 conb3 conse0 conse1 conse2 conse3 t0 t1 t2 t3 consb0 consb1 consb2 consb3 txt


estimates table educ_poldirev welfg_poldirev , /*
 */ b(%10.2f) se(%10.2f) p(%10.2f) stats(N) /*
 */ keep(importld importlag pdirvlag _IimXim _IimXpd _I1imXpd _IimXimXpd /*
 */ educlag educld welfglag welfgld exportgdplag exportgdpld lngdpcapld /*
 */ lngdpcaplag dependld dependlag polity_di_revld bn_cab_xoka_gd_zslag bn_cab_xoka_gd_zsld /*
 */ log_dt_dod_dect_cdlag log_dt_dod_dect_cdld year) label

