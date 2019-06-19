/****************************************************************************************************/
/*** DESCRIPTION:   REPLICATION CODE FOR "CLIMATIC FLUCTUATIONS AND THE DIFFUSION OF AGRICULTURE" ***/
/*** AUTHORS:       QUAMRUL ASHRAF AND STELIOS MICHALOPOULOS                                      ***/
/*** LAST REVISION: MARCH 27, 2014                                                                ***/
/****************************************************************************************************/

# delimit ;
set more off ;
set matsize 550 ;

clear all ;

set mem 50m ;

cd "C:\Research\AshrafMichalopoulos\replication\" ;

capture log close ;

log using "results\logs\gen_results_site.log", replace ;

use "data\neolithic_site.dta", clear ;


/***************************************************/
/*** CROSS-SITE REGRESSIONS [TABLE 5, TOP PANEL] ***/
/***************************************************/

/* COLUMN 1 */

reg uncalc14bp sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", replace tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 2 */

reg uncalc14bp sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 3 */

reg uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
test sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 4 */

reg uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
test sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 5 */

reg uncalc14bp sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
test sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 6 */

reg uncalc14bp sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
test sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 7 */

reg uncalc14bp sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
test sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 8 */

reg uncalc14bp sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
test sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 9 */

reg uncalc14bp sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
test sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv;

/* COLUMN 10 */

reg uncalc14bp sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
test sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table5a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) 
        sortvar(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist) ;
scalar drop jpval optcf optse optpv ;


/****************************************************************************************************************************/
/*** WALD TESTS FOR EXAMINING THE LOWER IMPORTANCE OF WINTER VOLATILITY IN CROSS-SITE REGRESSIONS [TABLE 5, BOTTOM PANEL] ***/
/****************************************************************************************************************************/

matrix table5b = J(4,6,0) ;

matrix colnames table5b = "spr_base" "spr_full" "sum_base" "sum_full" "aut_base" "aut_full" ;
matrix rownames table5b = "1st_chi2" "1st_pval" "2nd_chi2" "2nd_pval" ;

/* -------------------------- */
/* BASELINE MODEL COMPARISONS */
/* -------------------------- */

qui reg uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude europe ;
qui est store reg_spr_base ;
qui reg uncalc14bp sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude europe ;
qui est store reg_sum_base ;
qui reg uncalc14bp sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude europe ;
qui est store reg_aut_base ;
qui reg uncalc14bp sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude europe ;
qui est store reg_win_base ;

qui suest reg_spr_base reg_sum_base reg_aut_base reg_win_base, vce(cluster code) ;

/* COLUMN 1, ROW 1 */
test [reg_spr_base_mean]sd_interannual_spr_1901_2000 = [reg_win_base_mean]sd_interannual_win_1901_2000 ;
matrix table5b[1,1] = r(chi2) ;
matrix table5b[2,1] = r(p) ;

/* COLUMN 1, ROW 2 */
test [reg_spr_base_mean]sd_interannual_spr_1901_2000_sqr = [reg_win_base_mean]sd_interannual_win_1901_2000_sqr ;
matrix table5b[3,1] = r(chi2) ;
matrix table5b[4,1] = r(p) ;

/* COLUMN 3, ROW 1 */
test [reg_sum_base_mean]sd_interannual_sum_1901_2000 = [reg_win_base_mean]sd_interannual_win_1901_2000 ;
matrix table5b[1,3] = r(chi2) ;
matrix table5b[2,3] = r(p) ;

/* COLUMN 3, ROW 2 */
test [reg_sum_base_mean]sd_interannual_sum_1901_2000_sqr = [reg_win_base_mean]sd_interannual_win_1901_2000_sqr ;
matrix table5b[3,3] = r(chi2) ;
matrix table5b[4,3] = r(p) ;

/* COLUMN 5, ROW 1 */
test [reg_aut_base_mean]sd_interannual_aut_1901_2000 = [reg_win_base_mean]sd_interannual_win_1901_2000 ;
matrix table5b[1,5] = r(chi2) ;
matrix table5b[2,5] = r(p) ;

/* COLUMN 5, ROW 2 */
test [reg_aut_base_mean]sd_interannual_aut_1901_2000_sqr = [reg_win_base_mean]sd_interannual_win_1901_2000_sqr ;
matrix table5b[3,5] = r(chi2) ;
matrix table5b[4,5] = r(p) ;

/* ---------------------- */
/* FULL MODEL COMPARISONS */
/* ---------------------- */

qui reg uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe ;
qui est store reg_spr_full ;
qui reg uncalc14bp sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe ;
qui est store reg_sum_full ;
qui reg uncalc14bp sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe ;
qui est store reg_aut_full ;
qui reg uncalc14bp sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe ;
qui est store reg_win_full ;

qui suest reg_spr_full reg_sum_full reg_aut_full reg_win_full, vce(cluster code) ;

/* COLUMN 2, ROW 1 */
test [reg_spr_full_mean]sd_interannual_spr_1901_2000 = [reg_win_full_mean]sd_interannual_win_1901_2000 ;
matrix table5b[1,2] = r(chi2) ;
matrix table5b[2,2] = r(p) ;

/* COLUMN 2, ROW 2 */
test [reg_spr_full_mean]sd_interannual_spr_1901_2000_sqr = [reg_win_full_mean]sd_interannual_win_1901_2000_sqr ;
matrix table5b[3,2] = r(chi2) ;
matrix table5b[4,2] = r(p) ;

/* COLUMN 4, ROW 1 */
test [reg_sum_full_mean]sd_interannual_sum_1901_2000 = [reg_win_full_mean]sd_interannual_win_1901_2000 ;
matrix table5b[1,4] = r(chi2) ;
matrix table5b[2,4] = r(p) ;

/* COLUMN 4, ROW 2 */
test [reg_sum_full_mean]sd_interannual_sum_1901_2000_sqr = [reg_win_full_mean]sd_interannual_win_1901_2000_sqr ;
matrix table5b[3,4] = r(chi2) ;
matrix table5b[4,4] = r(p) ;

/* COLUMN 6, ROW 1 */
test [reg_aut_full_mean]sd_interannual_aut_1901_2000 = [reg_win_full_mean]sd_interannual_win_1901_2000 ;
matrix table5b[1,6] = r(chi2) ;
matrix table5b[2,6] = r(p) ;

/* COLUMN 6, ROW 2 */
test [reg_aut_full_mean]sd_interannual_aut_1901_2000_sqr = [reg_win_full_mean]sd_interannual_win_1901_2000_sqr ;
matrix table5b[3,6] = r(chi2) ;
matrix table5b[4,6] = r(p) ;

outtable using "results\tables\table5b", mat(table5b) replace format(%9.3f) ;
matrix drop table5b ;
est drop _all ;


/**********************************************************************************************/
/*** CROSS-SITE SCATTER PLOTS FOR REGRESSIONS BASED ON SPRING VOLATILITY [FIGURES 9 AND A6] ***/
/**********************************************************************************************/

/* QUADRATIC FIT */

qui reg uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
predict res, residuals ;
gen acpr = _b[sd_interannual_spr_1901_2000]*sd_interannual_spr_1901_2000 + _b[sd_interannual_spr_1901_2000_sqr]*sd_interannual_spr_1901_2000_sqr + res ;

twoway (scatter acpr sd_interannual_spr_1901_2000, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin)) || 
       (qfitci acpr sd_interannual_spr_1901_2000, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Spring Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure9.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg uncalc14bp sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
predict res1, residuals ;
qui reg sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
predict res2, residuals ;

twoway (scatter res1 res2, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin)) || 
       (lfitci res1 res2, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Spring Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA6a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg uncalc14bp sd_interannual_spr_1901_2000 mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
predict res1, residuals ;
qui reg sd_interannual_spr_1901_2000_sqr sd_interannual_spr_1901_2000 mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, vce(cluster code) ;
predict res2, residuals ;

twoway (scatter res1 res2, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin)) || 
       (lfitci res1 res2, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Interannual Std. Dev. of Spring Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA6b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;


/**********************************************************************/
/*** CROSS-SITE CLIMATE-SUITABILITY REGRESSIONS [TABLE A1, PANEL B] ***/
/**********************************************************************/

/* COLUMN 1 */

reg climate sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", replace tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Partial") 
        adjr2 nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) ;

/* COLUMN 2 */

reg climate sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude mean_elev sea_dist europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Full") 
        adjr2 nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) ;

/* COLUMN 3 */

reg climate sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Partial") 
        adjr2 nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) ;

/* COLUMN 4 */

reg climate sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude mean_elev sea_dist europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Full") 
        adjr2 nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) ;

/* COLUMN 5 */

reg climate sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Partial") 
        adjr2 nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) ;

/* COLUMN 6 */

reg climate sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude mean_elev sea_dist europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Full") 
        adjr2 nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) ;

/* COLUMN 7 */

reg climate sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Partial") 
        adjr2 nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) ;

/* COLUMN 8 */

reg climate sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude mean_elev sea_dist europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Full") 
        adjr2 nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) ;

/* COLUMN 9 */

reg climate sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Partial") 
        adjr2 nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) ;

/* COLUMN 10 */

reg climate sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude mean_elev sea_dist europe, vce(cluster code) ;
outreg2 using "results\tables\tableA1b", tex 
        bdec(3) tdec(3) rdec(2) 
        addtext("Set of Geographical Controls", "Full") 
        adjr2 nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) 
        sortvar(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) ;


/**********************************************************/
/*** CROSS-SITE SPATIAL REGRESSIONS [TABLE A2, PANEL B] ***/
/**********************************************************/

clear mata ;

spmat idistance dobj longitude latitude, id(site_id) dfunction(dhaversine) ;

/* COLUMN 1 */

spreg ml uncalc14bp sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,8] ;
scalar lamse = sqrt(V[8,8]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,9] ;
scalar rhose = sqrt(V[9,9]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", replace tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 2 */

spreg ml uncalc14bp sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,11] ;
scalar lamse = sqrt(V[11,11]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,12] ;
scalar rhose = sqrt(V[12,12]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 3 */

spreg ml uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,8] ;
scalar lamse = sqrt(V[8,8]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,9] ;
scalar rhose = sqrt(V[9,9]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 4 */

spreg ml uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,11] ;
scalar lamse = sqrt(V[11,11]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,12] ;
scalar rhose = sqrt(V[12,12]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 5 */

spreg ml uncalc14bp sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,8] ;
scalar lamse = sqrt(V[8,8]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,9] ;
scalar rhose = sqrt(V[9,9]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 6 */

spreg ml uncalc14bp sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,11] ;
scalar lamse = sqrt(V[11,11]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,12] ;
scalar rhose = sqrt(V[12,12]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 7 */

spreg ml uncalc14bp sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,8] ;
scalar lamse = sqrt(V[8,8]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,9] ;
scalar rhose = sqrt(V[9,9]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 8 */

spreg ml uncalc14bp sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,11] ;
scalar lamse = sqrt(V[11,11]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,12] ;
scalar rhose = sqrt(V[12,12]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 9 */

spreg ml uncalc14bp sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,8] ;
scalar lamse = sqrt(V[8,8]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,9] ;
scalar rhose = sqrt(V[9,9]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) eqkeep(uncalc14bp) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 10 */

spreg ml uncalc14bp sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_gcayonu latitude climate mean_elev sea_dist europe, id(site_id) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,11] ;
scalar lamse = sqrt(V[11,11]) ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,12] ;
scalar rhose = sqrt(V[12,12]) ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2b", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) eqkeep(uncalc14bp) 
        sortvar(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;


/**************************************************************/
/*** DESCRIPTIVE STATISTICS AND CORRELATIONS [TABLES B7-B8] ***/
/**************************************************************/

statsmat sd_intermonthly_1901_2000 sd_interannual_spr_1901_2000 sd_interannual_sum_1901_2000 sd_interannual_aut_1901_2000 sd_interannual_win_1901_2000 mean_intermonthly_1901_2000 mean_interannual_spr_1901_2000 mean_interannual_sum_1901_2000 mean_interannual_aut_1901_2000 mean_interannual_win_1901_2000 uncalc14bp ln_gcayonu latitude climate mean_elev sea_dist, stat(mean sd min max) mat(tableB7) ;
outtable using "results\tables\tableB7", mat(tableB7) replace format(%9.3f) ;
matrix drop tableB7 ;

corrtex sd_intermonthly_1901_2000 sd_interannual_spr_1901_2000 sd_interannual_sum_1901_2000 sd_interannual_aut_1901_2000 sd_interannual_win_1901_2000 mean_intermonthly_1901_2000 mean_interannual_spr_1901_2000 mean_interannual_sum_1901_2000 mean_interannual_aut_1901_2000 mean_interannual_win_1901_2000 uncalc14bp ln_gcayonu latitude climate mean_elev sea_dist, file("results\tables\tableB8") replace dig(3) ;


log close ;
