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

log using "results\logs\gen_results_country.log", replace ;

use "data\neolithic_country.dta", clear ;


/****************************************************************************/
/*** CROSS-COUNTRY REGRESSIONS BASED ON CONTEMPORARY VOLATILITY [TABLE 1] ***/
/****************************************************************************/

/* COLUMN 1 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", replace tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 2 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 3 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area geo_cond africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 4 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area plants animals africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 5 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area bio_cond africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 6 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 7 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 8 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Small Island Dummy", "Yes", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(landlocked island africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 9 */

reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table1", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Small Island Dummy", "Yes", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(landlocked island africa europe asia americas) 
        sortvar(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size geo_cond plants animals bio_cond mean_elev mean_rugg kgatr kgatemp) ;
scalar drop jpval optcf optse optpv ;


/**************************************************************************************************/
/*** CROSS-COUNTRY SCATTER PLOTS FOR REGRESSIONS BASED ON CONTEMPORARY VOLATILITY [FIGURES 4-5] ***/
/**************************************************************************************************/

/* QUADRATIC FIT */

qui reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res, residuals ;
gen acpr = _b[sd_intermonthly_1901_2000]*sd_intermonthly_1901_2000 + _b[sd_intermonthly_1901_2000_sqr]*sd_intermonthly_1901_2000_sqr + res ;

twoway (scatter acpr sd_intermonthly_1901_2000 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (qfitci acpr sd_intermonthly_1901_2000 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Intermonthly Std. Dev. of Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure4.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg yst sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Intermonthly Std. Dev. of Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure5a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg yst sd_intermonthly_1901_2000 mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_intermonthly_1901_2000_sqr sd_intermonthly_1901_2000 mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Intermonthly Std. Dev. of Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure5b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;


/********************************************************************************************/
/*** CROSS-COUNTRY REGRESSIONS BASED ON CONTEMPORARY SEASON-SPECIFIC VOLATILITY [TABLE 2] ***/
/********************************************************************************************/

/* COLUMN 1 */

reg yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", replace tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 2 */

reg yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Small Island Dummy", "Yes", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(landlocked island africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 3 */

reg yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 4 */

reg yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Small Island Dummy", "Yes", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(landlocked island africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 5 */

reg yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 6 */

reg yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Small Island Dummy", "Yes", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(landlocked island africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 7 */

reg yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Small Island Dummy", "No", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(africa europe asia americas) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 8 */

reg yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
test sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table2", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Small Island Dummy", "Yes", "Continent Dummies", "Yes") 
        adjr2 nocons 
        drop(landlocked island africa europe asia americas) 
        sortvar(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp) ;
scalar drop jpval optcf optse optpv ;


/**************************************************************************************************************************/
/*** CROSS-COUNTRY SCATTER PLOTS FOR REGRESSIONS BASED ON CONTEMPORARY SEASON-SPECIFIC VOLATILITY [FIGURES 6 AND A1-A4] ***/
/**************************************************************************************************************************/

/* --------------------------- */
/* PLOTS FOR SPRING VOLATILITY */
/* --------------------------- */

/* QUADRATIC FIT */

qui reg yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res, residuals ;
gen acpr = _b[sd_interannual_spr_1901_2000]*sd_interannual_spr_1901_2000 + _b[sd_interannual_spr_1901_2000_sqr]*sd_interannual_spr_1901_2000_sqr + res ;

twoway (scatter acpr sd_interannual_spr_1901_2000 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (qfitci acpr sd_interannual_spr_1901_2000 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Spring Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure6a.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg yst sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Spring Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA1a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg yst sd_interannual_spr_1901_2000 mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_spr_1901_2000_sqr sd_interannual_spr_1901_2000 mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Interannual Std. Dev. of Spring Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA1b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* --------------------------- */
/* PLOTS FOR SUMMER VOLATILITY */
/* --------------------------- */

/* QUADRATIC FIT */

qui reg yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res, residuals ;
gen acpr = _b[sd_interannual_sum_1901_2000]*sd_interannual_sum_1901_2000 + _b[sd_interannual_sum_1901_2000_sqr]*sd_interannual_sum_1901_2000_sqr + res ;

twoway (scatter acpr sd_interannual_sum_1901_2000 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (qfitci acpr sd_interannual_sum_1901_2000 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Summer Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure6b.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg yst sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Summer Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA2a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg yst sd_interannual_sum_1901_2000 mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_sum_1901_2000_sqr sd_interannual_sum_1901_2000 mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Interannual Std. Dev. of Summer Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA2b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* --------------------------- */
/* PLOTS FOR AUTUMN VOLATILITY */
/* --------------------------- */

/* QUADRATIC FIT */

qui reg yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res, residuals ;
gen acpr = _b[sd_interannual_aut_1901_2000]*sd_interannual_aut_1901_2000 + _b[sd_interannual_aut_1901_2000_sqr]*sd_interannual_aut_1901_2000_sqr + res ;

twoway (scatter acpr sd_interannual_aut_1901_2000 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (qfitci acpr sd_interannual_aut_1901_2000 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Autumn Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure6c.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg yst sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Autumn Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA3a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg yst sd_interannual_aut_1901_2000 mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_aut_1901_2000_sqr sd_interannual_aut_1901_2000 mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Interannual Std. Dev. of Autumn Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA3b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* --------------------------- */
/* PLOTS FOR WINTER VOLATILITY */
/* --------------------------- */

/* QUADRATIC FIT */

qui reg yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res, residuals ;
gen acpr = _b[sd_interannual_win_1901_2000]*sd_interannual_win_1901_2000 + _b[sd_interannual_win_1901_2000_sqr]*sd_interannual_win_1901_2000_sqr + res ;

twoway (scatter acpr sd_interannual_win_1901_2000 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (qfitci acpr sd_interannual_win_1901_2000 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Winter Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure6d.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg yst sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interannual Std. Dev. of Winter Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA4a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg yst sd_interannual_win_1901_2000 mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interannual_win_1901_2000_sqr sd_interannual_win_1901_2000 mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_cont==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_cont==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Interannual Std. Dev. of Winter Temperature, 1901-2000", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA4b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;


/*****************************************************************************************************************/
/*** WALD TESTS FOR EXAMINING THE LOWER IMPORTANCE OF WINTER VOLATILITY IN CROSS-COUNTRY REGRESSIONS [TABLE 3] ***/
/*****************************************************************************************************************/

matrix table3 = J(4,6,0) ;

matrix colnames table3 = "spr_base" "spr_full" "sum_base" "sum_full" "aut_base" "aut_full" ;
matrix rownames table3 = "1st_chi2" "1st_pval" "2nd_chi2" "2nd_pval" ;

/* -------------------------- */
/* BASELINE MODEL COMPARISONS */
/* -------------------------- */

qui reg yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1 ;
qui est store reg_spr_base ;
qui reg yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1 ;
qui est store reg_sum_base ;
qui reg yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1 ;
qui est store reg_aut_base ;
qui reg yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1 ;
qui est store reg_win_base ;

qui suest reg_spr_base reg_sum_base reg_aut_base reg_win_base, vce(robust) ;

/* COLUMN 1, ROW 1 */
test [reg_spr_base_mean]sd_interannual_spr_1901_2000 = [reg_win_base_mean]sd_interannual_win_1901_2000 ;
matrix table3[1,1] = r(chi2) ;
matrix table3[2,1] = r(p) ;

/* COLUMN 1, ROW 2 */
test [reg_spr_base_mean]sd_interannual_spr_1901_2000_sqr = [reg_win_base_mean]sd_interannual_win_1901_2000_sqr ;
matrix table3[3,1] = r(chi2) ;
matrix table3[4,1] = r(p) ;

/* COLUMN 3, ROW 1 */
test [reg_sum_base_mean]sd_interannual_sum_1901_2000 = [reg_win_base_mean]sd_interannual_win_1901_2000 ;
matrix table3[1,3] = r(chi2) ;
matrix table3[2,3] = r(p) ;

/* COLUMN 3, ROW 2 */
test [reg_sum_base_mean]sd_interannual_sum_1901_2000_sqr = [reg_win_base_mean]sd_interannual_win_1901_2000_sqr ;
matrix table3[3,3] = r(chi2) ;
matrix table3[4,3] = r(p) ;

/* COLUMN 5, ROW 1 */
test [reg_aut_base_mean]sd_interannual_aut_1901_2000 = [reg_win_base_mean]sd_interannual_win_1901_2000 ;
matrix table3[1,5] = r(chi2) ;
matrix table3[2,5] = r(p) ;

/* COLUMN 5, ROW 2 */
test [reg_aut_base_mean]sd_interannual_aut_1901_2000_sqr = [reg_win_base_mean]sd_interannual_win_1901_2000_sqr ;
matrix table3[3,5] = r(chi2) ;
matrix table3[4,5] = r(p) ;

/* ---------------------- */
/* FULL MODEL COMPARISONS */
/* ---------------------- */

qui reg yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1 ;
qui est store reg_spr_full ;
qui reg yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1 ;
qui est store reg_sum_full ;
qui reg yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1 ;
qui est store reg_aut_full ;
qui reg yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1 ;
qui est store reg_win_full ;

qui suest reg_spr_full reg_sum_full reg_aut_full reg_win_full, vce(robust) ;

/* COLUMN 2, ROW 1 */
test [reg_spr_full_mean]sd_interannual_spr_1901_2000 = [reg_win_full_mean]sd_interannual_win_1901_2000 ;
matrix table3[1,2] = r(chi2) ;
matrix table3[2,2] = r(p) ;

/* COLUMN 2, ROW 2 */
test [reg_spr_full_mean]sd_interannual_spr_1901_2000_sqr = [reg_win_full_mean]sd_interannual_win_1901_2000_sqr ;
matrix table3[3,2] = r(chi2) ;
matrix table3[4,2] = r(p) ;

/* COLUMN 4, ROW 1 */
test [reg_sum_full_mean]sd_interannual_sum_1901_2000 = [reg_win_full_mean]sd_interannual_win_1901_2000 ;
matrix table3[1,4] = r(chi2) ;
matrix table3[2,4] = r(p) ;

/* COLUMN 4, ROW 2 */
test [reg_sum_full_mean]sd_interannual_sum_1901_2000_sqr = [reg_win_full_mean]sd_interannual_win_1901_2000_sqr ;
matrix table3[3,4] = r(chi2) ;
matrix table3[4,4] = r(p) ;

/* COLUMN 6, ROW 1 */
test [reg_aut_full_mean]sd_interannual_aut_1901_2000 = [reg_win_full_mean]sd_interannual_win_1901_2000 ;
matrix table3[1,6] = r(chi2) ;
matrix table3[2,6] = r(p) ;

/* COLUMN 6, ROW 2 */
test [reg_aut_full_mean]sd_interannual_aut_1901_2000_sqr = [reg_win_full_mean]sd_interannual_win_1901_2000_sqr ;
matrix table3[3,6] = r(chi2) ;
matrix table3[4,6] = r(p) ;

outtable using "results\tables\table3", mat(table3) replace format(%9.3f) ;
matrix drop table3 ;
est drop _all ;


/*************************************************************************************/
/*** CROSS-COUNTRY REGRESSIONS BASED ON THE HISTORICAL-VOLATILITY SAMPLE [TABLE 4] ***/
/*************************************************************************************/

/* COLUMN 1 */

reg yst sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", replace tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 2 */

reg yst sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area geo_cond europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 3 */

reg yst sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(landlocked europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 4 */

reg yst sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area geo_cond mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(landlocked europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 5 */

reg yst sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr mean_interseasonal_1901_2000 ln_frontier_dist abslat area climate axis size europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 6 */

reg yst sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr mean_interseasonal_1901_2000 ln_frontier_dist abslat area geo_cond europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "No", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 7 */

reg yst sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr mean_interseasonal_1901_2000 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(landlocked europe) ;
scalar drop jpval optcf optse optpv ;

/* COLUMN 8 */

reg yst sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr mean_interseasonal_1901_2000 ln_frontier_dist abslat area geo_cond mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
test sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar jpval = r(p) ;
wherext sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr ;
scalar optcf = r(argext) ;
scalar optse = sqrt(r(Vargext)) ;
scalar optpv = 2 * normal(-abs(optcf / optse)) ;
outreg2 using "results\tables\table4", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Optimum", optcf, "Optimum S.E.", optse, "Optimum P-val.", optpv, "Joint Sig. P-val.", jpval) 
        addtext("Landlocked Dummy", "Yes", "Europe Dummy", "Yes") 
        adjr2 nocons 
        drop(landlocked europe) 
        sortvar(sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 sd_interseasonal_1901_2000 sd_interseasonal_1901_2000_sqr mean_interseasonal_1901_2000 ln_frontier_dist abslat area climate axis size geo_cond mean_elev mean_rugg) ;
scalar drop jpval optcf optse optpv ;


/*****************************************************************************************************/
/*** CROSS-COUNTRY SCATTER PLOTS FOR REGRESSIONS BASED ON HISTORICAL VOLATILITY [FIGURES 7 AND A5] ***/
/*****************************************************************************************************/

/* QUADRATIC FIT */

qui reg yst sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
predict res, residuals ;
gen acpr = _b[sd_interseasonal_1500_1900]*sd_interseasonal_1500_1900 + _b[sd_interseasonal_1500_1900_sqr]*sd_interseasonal_1500_1900_sqr + res ;

twoway (scatter acpr sd_interseasonal_1500_1900 if samp_hist==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (qfitci acpr sd_interseasonal_1500_1900 if samp_hist==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interseasonal Std. Dev. of Temperature, 1500-1900", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Quadratic Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure7.wmf", as(wmf) replace ;

drop acpr ;
drop res  ;

/* LINEAR FIT FOR 1ST-ORDER PARTIAL */

qui reg yst sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_hist==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_hist==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interseasonal Std. Dev. of Temperature, 1500-1900", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA5a.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;

/* LINEAR FIT FOR 2ND-ORDER PARTIAL */

qui reg yst sd_interseasonal_1500_1900 mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
predict res1, residuals ;
qui reg sd_interseasonal_1500_1900_sqr sd_interseasonal_1500_1900 mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;
predict res2, residuals ;

twoway (scatter res1 res2 if samp_hist==1, msymbol(O) msize(medium) mfcolor(gs8) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (lfitci res1 res2 if samp_hist==1, sort ciplot(rline) clwidth(medium) clcolor(gs0) blwidth(medthin) blcolor(gs0) blpattern(shortdash)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Thousand years since Neolithic Revolution", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Squared Interseasonal Std. Dev. of Temperature, 1500-1900", size(small)) 
        legend(order(3 2) rows(1) label(3 "Predicted (Linear Fit)") label(2 "95% CI") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figureA5b.wmf", as(wmf) replace ;

drop res1 ;
drop res2 ;


/************************************************************/
/*** ADDITIONAL CROSS-COUNTRY SCATTER PLOTS [FIGURES 2-3] ***/
/************************************************************/

/* CONTEMPORARY VS. HISTORICAL TEMPERATURE VOLATILITY */

twoway (scatter sd_interseasonal_1500_1900 sd_interseasonal_1901_2000 if samp_corr==1 & samp_hist==0, msymbol(O) msize(medium) mfcolor(gs16) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (scatter sd_interseasonal_1500_1900 sd_interseasonal_1901_2000 if samp_corr==1 & samp_hist==1, msymbol(O) msize(medium) mfcolor(gs8)  mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Interseasonal Std. Dev. of Temperature, 1500-1900", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interseasonal Std. Dev. of Temperature, 1901-2000", size(small)) 
        legend(order(1 2) rows(1) label(1 "Omitted Sample") label(2 "Regression Sample") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure2.wmf", as(wmf) replace ;

/* CONTEMPORARY VS. HISTORICAL MEAN TEMPERATURE */

twoway (scatter mean_interseasonal_1500_1900 mean_interseasonal_1901_2000 if samp_corr==1 & samp_hist==0, msymbol(O) msize(medium) mfcolor(gs16) mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)) || 
       (scatter mean_interseasonal_1500_1900 mean_interseasonal_1901_2000 if samp_corr==1 & samp_hist==1, msymbol(O) msize(medium) mfcolor(gs8)  mlcolor(gs2) mlwidth(thin) mlabel(code) mlabpos(12) mlabsize(1.75) mlabcolor(gs2)), 
        ylabel(,labsize(small) glcolor(gs14)) ytitle("Interseasonal Mean of Temperature, 1500-1900", size(small)) 
        xlabel(,labsize(small) glcolor(gs14)) xtitle("Interseasonal Mean of Temperature, 1901-2000", size(small)) 
        legend(order(1 2) rows(1) label(1 "Omitted Sample") label(2 "Regression Sample") size(vsmall)) 
        graphregion(color(white)) plotregion(color(white)) bgcolor(white) ;

graph export "results\figures\figure3.wmf", as(wmf) replace ;


/*************************************************************************/
/*** CROSS-COUNTRY CLIMATE-SUITABILITY REGRESSIONS [TABLE A1, PANEL A] ***/
/*************************************************************************/

/* COLUMN 1 */

oprobit climate sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", replace tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 2 */

oprobit climate sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 3 */

oprobit climate sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 4 */

oprobit climate sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 5 */

oprobit climate sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 6 */

oprobit climate sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 7 */

oprobit climate sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 8 */

oprobit climate sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 9 */

oprobit climate sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;

/* COLUMN 10 */

oprobit climate sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;
scalar psdlk = e(ll) ;
scalar psdr2 = e(r2_p) ;
outreg2 using "results\tables\tableA1a", tex 
        bdec(3) tdec(3) rdec(2) adec(2) 
        addstat("Log Pseudolikelihood", psdlk, "Pseudo R-squared", psdr2) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) 
        sortvar(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) ;
scalar drop psdlk psdr2 ;


/*************************************************************/
/*** CROSS-COUNTRY SPATIAL REGRESSIONS [TABLE A2, PANEL A] ***/
/*************************************************************/

clear mata ;

preserve ;

drop if samp_cont==0 ;

spmat idistance dobj cenlong cenlat, id(cid) dfunction(dhaversine) ;

/* COLUMN 1 */

spreg ml yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,12] / 100 ;
scalar lamse = sqrt(V[12,12]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,13] / 100 ;
scalar rhose = sqrt(V[13,13]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", replace tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 2 */

spreg ml yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,20] / 100 ;
scalar lamse = sqrt(V[20,20]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,21] / 100 ;
scalar rhose = sqrt(V[21,21]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 3 */

spreg ml yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,12] / 100 ;
scalar lamse = sqrt(V[12,12]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,13] / 100 ;
scalar rhose = sqrt(V[13,13]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 4 */

spreg ml yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,20] / 100 ;
scalar lamse = sqrt(V[20,20]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,21] / 100 ;
scalar rhose = sqrt(V[21,21]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 5 */

spreg ml yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,12] / 100 ;
scalar lamse = sqrt(V[12,12]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,13] / 100 ;
scalar rhose = sqrt(V[13,13]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 6 */

spreg ml yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,20] / 100 ;
scalar lamse = sqrt(V[20,20]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,21] / 100 ;
scalar rhose = sqrt(V[21,21]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 7 */

spreg ml yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,12] / 100 ;
scalar lamse = sqrt(V[12,12]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,13] / 100 ;
scalar rhose = sqrt(V[13,13]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 8 */

spreg ml yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,20] / 100 ;
scalar lamse = sqrt(V[20,20]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,21] / 100 ;
scalar rhose = sqrt(V[21,21]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 9 */

spreg ml yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,12] / 100 ;
scalar lamse = sqrt(V[12,12]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,13] / 100 ;
scalar rhose = sqrt(V[13,13]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Partial") 
        nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) eqkeep(yst) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

/* COLUMN 10 */

spreg ml yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas, id(cid) dlmat(dobj) elmat(dobj) ;
matrix b = e(b) ;
matrix V = e(V) ;
scalar lamcf = b[1,20] / 100 ;
scalar lamse = sqrt(V[20,20]) / 100 ;
scalar lampv = 2 * normal(-abs(lamcf / lamse)) ;
scalar rhocf = b[1,21] / 100 ;
scalar rhose = sqrt(V[21,21]) / 100 ;
scalar rhopv = 2 * normal(-abs(rhocf / rhose)) ;
outreg2 using "results\tables\tableA2a", tex 
        bdec(3) tdec(3) rdec(2) adec(3) 
        addstat("Lambda", lamcf, "Lambda S.E.", lamse, "Lambda P-val.", lampv, "Rho", rhocf, "Rho S.E.", rhose, "Rho P-val.", rhopv) 
        addtext("Set of Geographical Controls", "Full") 
        nocons 
        keep(sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) eqkeep(yst) 
        sortvar(sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr) ;
matrix drop b V ;
scalar drop lamcf lamse lampv rhocf rhose rhopv ;

restore ;


/**************************************************************/
/*** DESCRIPTIVE STATISTICS AND CORRELATIONS [TABLES B1-B6] ***/
/**************************************************************/

statsmat sd_intermonthly_1901_2000 mean_intermonthly_1901_2000 yst ln_frontier_dist abslat area climate axis size geo_cond plants animals bio_cond mean_elev mean_rugg kgatr kgatemp if samp_cont==1, stat(mean sd min max) mat(tableB1) ;
outtable using "results\tables\tableB1", mat(tableB1) replace format(%9.3f) ;
matrix drop tableB1 ;

statsmat sd_interannual_spr_1901_2000 sd_interannual_sum_1901_2000 sd_interannual_aut_1901_2000 sd_interannual_win_1901_2000 mean_interannual_spr_1901_2000 mean_interannual_sum_1901_2000 mean_interannual_aut_1901_2000 mean_interannual_win_1901_2000 if samp_cont==1, stat(mean sd min max) mat(tableB3) ;
outtable using "results\tables\tableB3", mat(tableB3) replace format(%9.3f) ;
matrix drop tableB3 ;

statsmat sd_interseasonal_1500_1900 mean_interseasonal_1500_1900 sd_interseasonal_1901_2000 mean_interseasonal_1901_2000 yst ln_frontier_dist abslat area climate axis size geo_cond mean_elev mean_rugg if samp_hist==1, stat(mean sd min max) mat(tableB5) ;
outtable using "results\tables\tableB5", mat(tableB5) replace format(%9.3f) ;
matrix drop tableB5 ;

corrtex sd_intermonthly_1901_2000 mean_intermonthly_1901_2000 yst ln_frontier_dist abslat area climate axis size geo_cond plants animals bio_cond mean_elev mean_rugg kgatr kgatemp if samp_cont==1, file("results\tables\tableB2") replace dig(3) ;

corrtex sd_interannual_spr_1901_2000 sd_interannual_sum_1901_2000 sd_interannual_aut_1901_2000 sd_interannual_win_1901_2000 mean_interannual_spr_1901_2000 mean_interannual_sum_1901_2000 mean_interannual_aut_1901_2000 mean_interannual_win_1901_2000 yst ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp if samp_cont==1, file("results\tables\tableB4") replace dig(3) ;

corrtex sd_interseasonal_1500_1900 mean_interseasonal_1500_1900 sd_interseasonal_1901_2000 mean_interseasonal_1901_2000 yst ln_frontier_dist abslat area climate axis size geo_cond mean_elev mean_rugg if samp_hist==1, file("results\tables\tableB6") replace dig(3) ;


log close ;
