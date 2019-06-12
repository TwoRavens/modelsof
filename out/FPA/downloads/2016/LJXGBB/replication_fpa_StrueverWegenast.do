
log using replication_fpa__StrueverWegenast.log

***************************************************************
***************************************************************
***                                                         ***
***           The Hard Power of Natural Resource:           ***
*** Oil and the Outbreak of Militarized Interstate Disputes ***
***                                                         ***
***             Georg Strüver & Tim Wegenast                ***
***                                                         ***
***************************************************************
***************************************************************



              *******************************
              ***            I.           *** 
              ***  Tables in the Article  ***
		  	  *******************************
			

*** TABLE 1: OIL AND MID ONSET: UNDIRECTED DYADS (UDD)
use replication_fpa_StrueverWegenast_udd_short.dta, clear
local  controls_udd "dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3"

eststo: qui logit onset `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** FIGURE 1: PREDICTIVE MARGINS OF OIL ON MID ONSET (UNDIRECTED DYADS)
qui logit onset oil_value_nom_GDP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
mcp oil_value_nom_GDP_higher_l1, var1(20) ci ///
	plotopts(yscale(range(0 .08)) ylabel(0(.02).08) ytick(0(.01).08) ///
	xtitle("Oil production/GDP, higher level", size(small)) subtitle("(a)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot1.gph, replace)) sh

qui logit onset oil_value_nom_LOG1_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
mcp oil_value_nom_LOG1_higher_l1, var1(20) ci ///
	plotopts(yscale(range(0 .08)) ylabel(0(.02).08) ytick(0(.01).08) ///
	xtitle("Oil production (log), higher level", size(small)) subtitle("(b)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot2.gph, replace)) sh

qui logit onset L_RESERVES_LOG1_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
mcp L_RESERVES_LOG1_higher, var1(20) ci ///
	plotopts(yscale(range(0 .08)) ylabel(0(.02).08) ytick(0(.01).08) ///
	xtitle("Oil reserves (log), higher level", size(small)) subtitle("(c)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot3.gph, replace)) sh
	
qui logit onset net_oil_exports_value2_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
mcp net_oil_exports_value2_higher_l1 if net_oil_exports_value2_higher_l1>0, var1(20) ci ///
	plotopts(yscale(range(0 .08)) ylabel(0(.02).08) ytick(0(.01).08) ///
	xtitle("Net oil exports, higher level", size(small)) subtitle("(d)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot4.gph, replace)) sh
	
gr combine plot1.gph plot2.gph ///
		   plot3.gph plot4.gph ///
		   , col(2) row(3) graphregion(color(white)) note("95% confidence intervals shaded in grey.", size(small))  ///
		   graphregion(margin(zero))


*** TABLE 2: OIL AND MID ONSET: DIRECTED DYADS (DD)   
use replication_fpa_StrueverWegenast_dd_short.dta, clear
local  controls_dd "c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3"
est clear

eststo: qui logit onset `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** CORRELATIONS
use replication_fpa_StrueverWegenast_m_short.dta, clear

* Section Weak State-Society Linkages
corr oil_value_nom_POP f1.lnontaxrev2 taxgdp_best

* Militarization and Resource Wars
corr oil_value_nom milex


*** SELECTED ROBUSTNESS CHECKS MENTIONED IN THE MAIN TEXT

*** Models of Table 1: Undirected Dyads
use replication_fpa_StrueverWegenast_udd_short.dta, clear

* Excl. U.S. and Russia 
eststo: qui logit onset dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

eststo: qui logit onset_nonfatal dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

eststo: qui logit onset_fatal dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

* Rare event logit
eststo: qui relogit onset dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

* Post-1973
eststo: qui logit onset dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

* Exclusion of Gulf War 1990/1991
eststo: qui logit onset oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** Models of Table 2: Directed Dyads
use replication_fpa_StrueverWegenast_dd_short.dta, clear

* Excl. U.S. and Russia 
eststo: qui logit onset c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

eststo: qui logit onset_nonfatal c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_nonfatal net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

eststo: qui logit onset_fatal c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
eststo: qui logit onset_fatal net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1 & us_rus_dyad==0, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

* Rare event logit
eststo: qui relogit onset c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
eststo: qui relogit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

* Post-1973
eststo: qui logit onset c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
eststo: qui  logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & year>=1973, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear

* Exclusion of Gulf War 1990/1991
eststo: qui logit onset c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
eststo: qui  logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3 if pol_rel==1 & cwongonm!=3957, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


              ***********************************
              ***             II.             *** 
              ***  Online Supporting Material ***
		  	  ***********************************
			  
			  
*** TABLE S-1: VARIABLE DEFINITIONS AND DATA SOURCES


*** TABLE S-2: DESCRIPTIVE STATISTICS - undirected dyads
use replication_fpa_StrueverWegenast_udd_short.dta, clear

estpost sum onset onset_nonfatal onset_fatal onset_lowfatal onset_highfatal ///
			oil_value_nom_POP_higher oil_value_nom_POP_lower  ///
			oil_value_nom_GDP_higher oil_value_nom_GDP_lower  ///
			oil_value_nom_LOG1_higher oil_value_nom_LOG1_lower ///
			oil_value_nom2_higher oil_value_nom2_lower  ///
			f1_L_RESERVES_LOG1_higher f1_L_RESERVES_LOG1_lower ///
			f1_L_RESERVES_higher f1_L_RESERVES_lower /// 
			f1_L_PC_RESERVES_higher f1_L_PC_RESERVES_lower ///
			net_oil_exports_value2_higher net_oil_exports_value2_lower ///
			milex_higher2_l1 armsimports_higher_l1 onepolautonomy_l1 taxgdp_best_lower_l1 lnontaxrev2_higher oneincidencev412_l1 maccetot_higher_l1 ///
			jc_radoil_c1 jc_radoil_c2 jc_radoil_any ///
			dyadictradedep_lower democ_lower polity2diff balanceofforce bothminor contigland ln_distance pol_rel ///
			onset_t1 onset_t2 onset_t3 ///
			onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 ///
			onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 ///
			onset_lowfatal_t1 onset_lowfatal_t2 onset_lowfatal_t3 ///
			onset_highfatal_t1 onset_highfatal_t2 onset_highfatal_t3
			
*** TABLE S-2: DESCRIPTIVE STATISTICS - directed dyads
use replication_fpa_StrueverWegenast_dd_short.dta, clear

estpost sum onset onset_fatal onset_nonfatal onset_lowfatal onset_highfatal revisionist ///
			revisionist_fatal revisionist_nonfatal revisionist_lowfatal revisionist_highfatal ///
			oil_value_nom_POP_c1 oil_value_nom_POP_c2 ///
			oil_value_nom_GDP_c1 oil_value_nom_GDP_c2 ///
			oil_value_nom_LOG1_c1 oil_value_nom_LOG1_c2 ///
			oil_value_nom2_c1 oil_value_nom2_c2 ///
			f1_L_RESERVES_LOG1_c1 f1_L_RESERVES_LOG1_c2 ///
			f1_L_RESERVES_c1 f1_L_RESERVES_c2 ///
			f1_L_PC_RESERVES_c1 f1_L_PC_RESERVES_c2 ///
			net_oil_exports_value2_c1 net_oil_exports_value2_c2 ///
			jc_radoil_c1 jc_radoil_c2 ///
			c1_dyadictradedep c2_dyadictradedep ///
			c1_democ c2_democ_l1 polity2diff ///
			c1_polity2Xdiff balanceofforce ///
			c1_powerratio bothminor contigland ln_distance ///		
			onset_t1 onset_t2 onset_t3 ///
			onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 ///
			onset_lowfatal_t1 onset_lowfatal_t2 onset_lowfatal_t3 ///
			onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 ///
			onset_highfatal_t1 onset_highfatal_t2 onset_highfatal_t3 ///
			revisionist_t1 revisionist_t2 revisionist_t3 ///
			revisionist_fatal_t1 revisionist_fatal_t2 revisionist_fatal_t3 ///
			revisionist_lowfatal_t1 revisionist_lowfatal_t2 revisionist_lowfatal_t3 ///
			revisionist_nonfatal_t1 revisionist_nonfatal_t2 revisionist_nonfatal_t3 ///
			revisionist_highfatal_t1 revisionist_highfatal_t2 revisionist_highfatal_t3


*** FIGURE S-1: TWO-WAY SCATTERPLOTS OF THE DIFFERENT OPERATIONALIZATIONS OF OIL			
use replication_fpa_StrueverWegenast_m_short.dta, clear

* (a) Oil production vs. Petroleum reserves
corr oil_value_nom2 f1.L_RESERVES
twoway  (lfit oil_value_nom2 f1.L_RESERVES) (scatter oil_value_nom2 f1.L_RESERVES, mlabel(abbrev)), ///
		legend(off) ytitle("Oil production") xtitle("Petroleum reserves") graphregion(color(white)) bgcolor(white)

* (b) Oil production vs. Oil production per capita
corr oil_value_nom2 oil_value_nom_POP
twoway  (lfit oil_value_nom2 oil_value_nom_POP) (scatter oil_value_nom2 oil_value_nom_POP, mlabel(abbrev)), ///
		legend(off) ytitle("Oil production") xtitle("Oil production per capita") graphregion(color(white)) bgcolor(white) 
		
* (c) Oil production vs. Oil production/GDP		
corr oil_value_nom2 oil_value_nom_GDP
twoway  (lfit oil_value_nom2 oil_value_nom_GDP) (scatter oil_value_nom2 oil_value_nom_GDP, mlabel(abbrev)), ///
		legend(off) ytitle("Oil production") xtitle("Oil production/GDP") graphregion(color(white)) bgcolor(white) 	

* (d) Oil production vs. Net oil exports		
corr oil_value_nom2 net_oil_exports_value2
twoway  (lfit oil_value_nom2 net_oil_exports_value2) (scatter oil_value_nom2 net_oil_exports_value2, mlabel(abbrev)), ///
		legend(off) ytitle("Oil production") xtitle("Net oil exports") graphregion(color(white)) bgcolor(white)
		
* (e) Petroleum reserves vs. Petroleum reserves per capita
corr L_RESERVES L_PC_RESERVES
twoway  (lfit L_RESERVES L_PC_RESERVES) (scatter L_RESERVES L_PC_RESERVES, mlabel(abbrev)), ///
		legend(off) ytitle("Petroleum reserves") xtitle("Petroleum reserves per capita") graphregion(color(white)) bgcolor(white)

* (f) Petroleum reserves vs. Net oil exports
corr f1.L_RESERVES net_oil_exports_value2 
twoway  (lfit f1.L_RESERVES net_oil_exports_value2) (scatter f1.L_RESERVES net_oil_exports_value2, mlabel(abbrev)), ///
		legend(off) ytitle("Petroleum reserves") xtitle("Net oil exports") graphregion(color(white)) bgcolor(white) 
	

*** Table S-3: CORRELATION MATRICES OF OIL MEASURES
* (a) Correlation of oil measures (excl. net oil exports)
corr oil_value_nom2 oil_value_nom_LOG1 oil_value_nom_POP oil_value_nom_GDP oilrent oilrent_gdp f1.L_RESERVES f1.L_RESERVES_LOG1 f1.L_PC_RESERVES jc_oil_state jc_radoil
* (b) Correlation of oil measures (all oil-related independent variables)
corr oil_value_nom2 oil_value_nom_LOG1 oil_value_nom_POP oil_value_nom_GDP oilrent oilrent_gdp f1.L_RESERVES f1.L_RESERVES_LOG1 f1.L_PC_RESERVES net_oil_exports_value2 jc_oil_state jc_radoil


***************************
*** I. UNDIRECTED DYADS ***
***************************
use replication_fpa_StrueverWegenast_udd_short.dta, clear
est clear
local  controls_udd "dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3"


*** TABLE S-4: OIL AND MID ONSET: UNDIRECTED DYADS (SAMPLE OF NON-MISSING OBSERVATIONS)
eststo: qui logit onset `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 `controls_udd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-5: OIL AND MID ONSET: UNDIRECTED DYADS AND ALTERNATIVE MEASUREMENTS OF OIL
eststo: qui logit onset l1.oil_value_nom2_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_lower_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_lower_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_lower_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_lower `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_lower `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_lower_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** FIGURE S-2: PREDICTIVE MARGINS OF ABSOLUTE OIL PRODUCTION AND RESERVES ON MID ONSET (UNDIRECTED DYADS)
qui logit onset l1_oil_value_nom2_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
mcp l1_oil_value_nom2_higher, var1(20) ci ///
	plotopts(yscale(range(0 .12)) ylabel(0(.02).12) ytick(0(.01).12) ///
	xtitle("Oil production, higher level", size(small)) subtitle("(a)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot5.gph, replace)) sh

qui logit onset L_RESERVES_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)	
mcp L_RESERVES_higher, var1(20) ci ///
	plotopts(yscale(range(0 .12)) ylabel(0(.02).12) ytick(0(.01).12) ///
	xtitle("Oil reserves, higher level", size(small)) subtitle("(b)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot6.gph, replace)) sh
	
gr combine plot5.gph plot6.gph ///
		   , col(2) row(3) graphregion(color(white)) note("95% confidence intervals shaded in grey.", size(small))  ///
		   graphregion(margin(zero))


*** TABLE S-6: OIL AND MID ONSET: ALL UNDIRECTED DYADS
eststo: qui logit onset `controls_udd', rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 `controls_udd', rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 `controls_udd', rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 `controls_udd', rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher `controls_udd', rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher `controls_udd', rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 `controls_udd', rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-7: OIL AND MID ONSET: UNDIRECTED DYADS AND REGIONAL CONTROLS
eststo: qui logit onset  rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 rg* `controls_udd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-8: OIL AND MID ONSET: UNDIRECTED DYADS AND NON-FATAL MIDS
eststo: qui logit onset_nonfatal dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-9: OIL AND MID ONSET: UNDIRECTED DYADS AND FATAL MIDS
eststo: qui logit onset_fatal dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal net_oil_exports_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-10: OIL AND MID ONSET: UNDIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY PETROSTATES
eststo: qui logit onset l1.jc_radoil_any `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_higher_l1 ROL_oil_value_nom_POP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_higher_l1 ROL_oil_value_nom_GDP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_higher_l1 ROL_oil_value_nom_LOG1_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_higher ROL_L_RESERVES_LOG1_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_higher ROL_L_PC_RESERVES_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_higher_l1 ROL_net_oil_exp_value2_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-11: OIL AND MID ONSET: UNDIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY PETROSTATES ON THE OUTBREAK OF NON-FATAL DISPUTES
eststo: qui logit onset_nonfatal l1.jc_radoil_any dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_POP_higher_l1 ROL_oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_GDP_higher_l1 ROL_oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_LOG1_higher_l1 ROL_oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_RESERVES_LOG1_higher ROL_L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_PC_RESERVES_higher ROL_L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal net_oil_exports_value2_higher_l1 ROL_net_oil_exp_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-12: OIL AND MID ONSET: UNDIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY GOVERNMENTS
eststo: qui logit onset l1.jc_radicalleader_any `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.oil_value_nom_POP_higher_l1##RL_oil_value_nom_POP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.oil_value_nom_GDP_higher_l1##RL_oil_value_nom_GDP_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.oil_value_nom_LOG1_higher_l1##RL_oil_value_nom_LOG1_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.L_RESERVES_LOG1_higher##RL_L_RESERVES_LOG1_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.L_PC_RESERVES_higher##RL_L_PC_RESERVES_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.net_oil_exports_value2_higher_l1##RL_net_oil_exp_value2_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-13: OIL AND MID ONSET: UNDIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY GOVERNMENTS ON THE OUTBREAK OF NON-FATAL DISPUTES
eststo: qui logit onset_nonfatal l1.jc_radicalleader_any dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.oil_value_nom_POP_higher_l1##RL_oil_value_nom_POP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.oil_value_nom_GDP_higher_l1##RL_oil_value_nom_GDP_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.oil_value_nom_LOG1_higher_l1##RL_oil_value_nom_LOG1_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.L_RESERVES_LOG1_higher##RL_L_RESERVES_LOG1_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.L_PC_RESERVES_higher##RL_L_PC_RESERVES_higher dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.net_oil_exports_value2_higher_l1##RL_net_oil_exp_value2_higher_l1 dyadictradedep_lower_l1 democ_lower_l1 polity2diff_l1 balanceofforce_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-14: POSSIBLE PATHWAYS LINKING OIL TO MID ONSET: UNDIRECTED DYADS
eststo: qui logit onset milex_higher2_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset armsimports_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset onepolautonomy_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset taxgdp_best_lower_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset lnontaxrev2_higher `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oneincidencev412_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset maccetot_higher_l1 `controls_udd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


**************************
*** II. DIRECTED DYADS ***
**************************
use replication_fpa_StrueverWegenast_dd_short.dta, clear
local  controls_dd "c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_t1 onset_t2 onset_t3"
est clear


*** TABLE S-15: OIL AND MID ONSET: DIRECTED DYADS (SAMPLE OF NON-MISSING OBSERVATIONS)
eststo: qui logit onset `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-16: OIL AND MID ONSET: DIRECTED DYADS AND THE ROLE OF REVISIONISM
eststo: qui logit revisionist c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit revisionist oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit revisionist oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit revisionist oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit revisionist L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit revisionist L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit revisionist net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-17: OIL AND MID ONSET: DIRECTED DYADS AND THE ROLE OF REVISIONISM (SAMPLE OF NON-MISSING OBSERVATIONS)
eststo: qui logit revisionist c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit revisionist oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit revisionist oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit revisionist oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit revisionist L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit revisionist L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit revisionist net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance revisionist_t1 revisionist_t2 revisionist_t3 if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-18: OIL AND MID ONSET: DIRECTED DYADS AND ABSOLUTE MEASUREMENTS OF OIL
eststo: qui logit onset `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset l1.oil_value_nom2_c1 l1.oil_value_nom2_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_c1 L_RESERVES_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset l1.oil_value_nom2_c1 l1.oil_value_nom2_c2 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_c1 L_RESERVES_c2 `controls_dd' if pol_rel==1 & nonmiss==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** FIGURE S-3: PREDICTIVE MARGINS OF OIL ON MID ONSET (DIRECTED DYADS)
qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp oil_value_nom_GDP_c1_l1, var1(20) ci ///
	plotopts(yscale(range(0 .07)) ylabel(0(.02).07) ytick(0(.01).07) ///
	xtitle("Oil production/GDP", size(small))  title("{bf:Side A}", size(medsmall)) subtitle("(a)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot1.gph, replace)) sh
mcp oil_value_nom_GDP_c2_l1, var1(20) ci ///
	plotopts(yscale(range(0 .07)) ylabel(0(.02).07) ytick(0(.01).07) ///
	xtitle("Oil production/GDP", size(small))  title("{bf:Side B}", size(medsmall)) subtitle("(b)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot2.gph, replace)) sh

qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp oil_value_nom_LOG1_c1_l1, var1(20) ci ///
	plotopts(yscale(range(0 .07)) ylabel(0(.02).07) ytick(0(.01).07) ///
	xtitle("Oil production (log)", size(small))  subtitle("(c)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot3.gph, replace)) sh
mcp oil_value_nom_LOG1_c2_l1, var1(20) ci ///
	plotopts(yscale(range(0 .07)) ylabel(0(.02).07) ytick(0(.01).07) ///
	xtitle("Oil production (log)", size(small))  subtitle("(d)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot4.gph, replace)) sh	

qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp L_RESERVES_LOG1_c1, var1(20) ci ///
	plotopts(yscale(range(0 .07)) ylabel(0(.02).07) ytick(0(.01).07) ///
	xtitle("Petroleum reserves (log)", size(small))  subtitle("(e)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot5.gph, replace)) sh
mcp L_RESERVES_LOG1_c2, var1(20) ci ///
	plotopts(yscale(range(0 .07)) ylabel(0(.02).07) ytick(0(.01).07) ///
	xtitle("Petroleum reserves (log)", size(small))  subtitle("(f)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot6.gph, replace)) sh	
	
qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp L_PC_RESERVES_c1, var1(20) ci ///
	plotopts(yscale(range(-0.01 .07)) ylabel(-0.01(.02).07) ytick(-0.01(.01).07) ///
	xtitle("Petroleum reserves per capita", size(small))  subtitle("(g)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot7.gph, replace)) sh
mcp L_PC_RESERVES_c2, var1(20) ci ///
	plotopts(yscale(range(-0.01 .07)) ylabel(-0.01(.02).07) ytick(-0.01(.01).07) ///
	xtitle("Petroleum reserves per capita", size(small))  subtitle("(h)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot8.gph, replace)) sh
	
qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp net_oil_exports_value2_c1_l1 if net_oil_exports_value2_c1_l1>0, var1(20) ci ///
	plotopts(yscale(range(-0.01 .07)) ylabel(-0.01(.02).07) ytick(-0.01(.01).07) ///
	xtitle("Net oil exports", size(small))  title("{bf:Side A}", size(medsmall)) subtitle("(i)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot9.gph, replace)) sh
mcp net_oil_exports_value2_c2_l1 if net_oil_exports_value2_c2_l1>0, var1(20) ci ///
	plotopts(yscale(range(-0.01 .07)) ylabel(-0.01(.02).07) ytick(-0.01(.01).07) ///
	xtitle("Net oil exports", size(small))  title("{bf:Side B}", size(medsmall)) subtitle("(j)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot10.gph, replace)) sh

qui logit onset oil_value_nom2_c1_l1 oil_value_nom2_c2_l1 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp oil_value_nom2_c1_l1, var1(20) ci ///
	plotopts(yscale(range(0 .12)) ylabel(0(.02).12) ytick(0(.01).12) ///
	xtitle("Oil production", size(small)) subtitle("(k)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot11.gph, replace)) sh
mcp oil_value_nom2_c2_l1, var1(20) ci ///
	plotopts(yscale(range(0 .12)) ylabel(0(.02).12) ytick(0(.01).12) ///
	xtitle("Oil production", size(small))  subtitle("(l)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot12.gph, replace)) sh	

qui logit onset L_RESERVES_c1 L_RESERVES_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
mcp L_RESERVES_c1, var1(20) ci ///
	plotopts(yscale(range(0 .12)) ylabel(0(.02).12) ytick(0(.01).12) ///
	xtitle("Oil reserves", size(small)) subtitle("(m)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot13.gph, replace)) sh
mcp L_RESERVES_c2, var1(20) ci ///
	plotopts(yscale(range(0 .12)) ylabel(0(.02).12) ytick(0(.01).12) ///
	xtitle("Oil reserves", size(small))  subtitle("(n)", ring(1) pos(10)) ///
	graphregion(color(white)) bgcolor(white) ///
	saving(plot14.gph, replace)) sh		

gr combine plot1.gph plot2.gph ///
		   plot3.gph plot4.gph ///
		   , col(2) row(4) graphregion(color(white)) note("95% confidence intervals shaded in grey.", size(small))  ///
		   graphregion(margin(zero))

gr combine plot5.gph plot6.gph ///
      	   plot7.gph plot8.gph ///
		   , col(2) row(4) graphregion(color(white)) note("95% confidence intervals shaded in grey.", size(small))  ///
		   graphregion(margin(zero))

gr combine plot9.gph plot10.gph ///
		   plot11.gph plot12.gph ///
		   , col(2) row(4) graphregion(color(white)) note("95% confidence intervals shaded in grey.", size(small))  ///
		   graphregion(margin(zero))
		
gr combine plot13.gph plot14.gph ///
		   , col(2) row(4) graphregion(color(white)) note("95% confidence intervals shaded in grey.", size(small))  ///
		   graphregion(margin(zero))

eststo clear
	

*** TABLE S-19: OIL AND MID ONSET: ALL DIRECTED DYADS
eststo: qui logit onset `controls_dd', rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 `controls_dd', rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 `controls_dd', rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 `controls_dd', rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd', rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd', rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 `controls_dd', rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-20: OIL AND MID ONSET: DIRECTED DYADS AND REGIONAL CONTROLS
eststo: qui logit onset  rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 rlrx* `controls_dd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-21: OIL AND MID ONSET: DIRECTED DYADS AND NON-FATAL MIDS
eststo: qui logit onset_nonfatal c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-22: OIL AND MID ONSET: DIRECTED DYADS AND FATAL MIDS
eststo: qui logit onset_fatal c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal L_PC_RESERVES_c1 L_PC_RESERVES_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_fatal net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_fatal_t1 onset_fatal_t2 onset_fatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-23: OIL RESERVES AND MID ONSET: DIRECTED DYADS AND THE EFFECT COUNTRY SIZE
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd' if pol_rel==1 & gle_pop_c2>=4000 & gle_pop_c2!=., rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd' if pol_rel==1 & gle_pop_c2>=4000 & gle_pop_c2!=., rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 `controls_dd' if pol_rel==1 & gle_pop_c2<4000 & gle_pop_c2!=., rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 `controls_dd' if pol_rel==1 & gle_pop_c2<4000 & gle_pop_c2!=., rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-24: OIL AND MID ONSET: DIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY PETROSTATES
eststo: qui logit onset jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset L_PC_RESERVES_c1 L_PC_RESERVES_c2 jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 jc_radoil_c1 jc_radoil_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-25: OIL AND MID ONSET: DIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY PETROSTATES ON THE OUTBREAK OF NON-FATAL DISPUTES
eststo: qui logit onset_nonfatal jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_POP_c1_l1 oil_value_nom_POP_c2_l1 jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_GDP_c1_l1 oil_value_nom_GDP_c2_l1 jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal oil_value_nom_LOG1_c1_l1 oil_value_nom_LOG1_c2_l1 jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_RESERVES_LOG1_c1 L_RESERVES_LOG1_c2 jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal L_PC_RESERVES_c1 L_PC_RESERVES_c2 jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal net_oil_exports_value2_c1_l1 net_oil_exports_value2_c2_l1 jc_radoil_c1 jc_radoil_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-26: OIL AND MID ONSET: DIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY GOVERNMENTS
eststo: qui logit onset l1.jc_radicalleader_c1 l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.oil_value_nom_POP_c1_l1##l1.jc_radicalleader_c1 c.oil_value_nom_POP_c2_l1##l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.oil_value_nom_GDP_c1_l1##l1.jc_radicalleader_c1 c.oil_value_nom_GDP_c2_l1##l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.oil_value_nom_LOG1_c1_l1##l1.jc_radicalleader_c1 c.oil_value_nom_LOG1_c2_l1##l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.L_RESERVES_LOG1_c1##l1.jc_radicalleader_c1 c.L_RESERVES_LOG1_c2##l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.L_PC_RESERVES_c1##l1.jc_radicalleader_c1 c.L_PC_RESERVES_c2##l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset c.net_oil_exports_value2_c1_l1##l1.jc_radicalleader_c1 c.net_oil_exports_value2_c2_l1##l1.jc_radicalleader_c2 `controls_dd' if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-27: OIL AND MID ONSET: DIRECTED DYADS AND THE IMPACT OF REVOLUTIONARY GOVERNMENTS ON THE OUTBREAK OF NON-FATAL DISPUTES
eststo: qui logit onset_nonfatal l1.jc_radicalleader_c1 l1.jc_radicalleader_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.oil_value_nom_POP_c1_l1##l1.jc_radicalleader_c1 c.oil_value_nom_POP_c2_l1##l1.jc_radicalleader_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.oil_value_nom_GDP_c1_l1##l1.jc_radicalleader_c1 c.oil_value_nom_GDP_c2_l1##l1.jc_radicalleader_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.oil_value_nom_LOG1_c1_l1##l1.jc_radicalleader_c1 c.oil_value_nom_LOG1_c2_l1##l1.jc_radicalleader_c2  c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.L_RESERVES_LOG1_c1##l1.jc_radicalleader_c1 c.L_RESERVES_LOG1_c2##l1.jc_radicalleader_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.L_PC_RESERVES_c1##l1.jc_radicalleader_c1 c.L_PC_RESERVES_c2##l1.jc_radicalleader_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
eststo: qui logit onset_nonfatal c.net_oil_exports_value2_c1_l1##l1.jc_radicalleader_c1 c.net_oil_exports_value2_c2_l1##l1.jc_radicalleader_c2 c1_dyadictradedep_l1 c2_dyadictradedep_l1 c1_democ_l1 c2_democ_l1 polity2diff_l1 c1_polity2Xdiff_l1 balanceofforce_l1 c1_powerratio_l1 bothminor contigland ln_distance onset_nonfatal_t1 onset_nonfatal_t2 onset_nonfatal_t3 if pol_rel==1, rob cluster(dyadid)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


******************
*** II. MONADS ***
******************
use replication_fpa_StrueverWegenast_m_short.dta, clear


*** TABLE S-28: OIL AND MID ONSET: CONFLICT INVOLVEMENT
eststo: qui logit midonset l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset l1.oil_value_nom_POP l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset l1.oil_value_nom_GDP l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset l1.oil_value_nom_LOG1 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset L_RESERVES_LOG1 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset L_PC_RESERVES l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset net_oil_exports_value2 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_peaceyrs_t1 midonset_peaceyrs_t2 midonset_peaceyrs_t3, r cluster(ccode)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-29: OIL AND MID ONSET: AGGRESSOR MIDS (SIDE A)	
eststo: qui logit midonset_sidea l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sidea l1.oil_value_nom_POP l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sidea l1.oil_value_nom_GDP l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sidea l1.oil_value_nom_LOG1 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sidea L_RESERVES_LOG1 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sidea L_PC_RESERVES l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sidea net_oil_exports_value2 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sidea_peaceyrs_t1 midonset_sidea_peaceyrs_t2 midonset_sidea_peaceyrs_t3, r cluster(ccode)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


*** TABLE S-30: OIL AND MID ONSET: DEFENDER MIDS (SIDE B)
eststo: qui logit midonset_sideb l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sideb l1.oil_value_nom_POP l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sideb l1.oil_value_nom_GDP l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sideb l1.oil_value_nom_LOG1 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sideb L_RESERVES_LOG1 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sideb L_PC_RESERVES l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
eststo: qui logit midonset_sideb net_oil_exports_value2 l1.democ_prie l1.prie_capabilityratio_3yrmavg l1.tradeopenness total majpow midonset_sideb_peaceyrs_t1 midonset_sideb_peaceyrs_t2 midonset_sideb_peaceyrs_t3, r cluster(ccode)
esttab ,se scalars(N chi2 r2_p) replace label  mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
eststo clear


log off
log close



















