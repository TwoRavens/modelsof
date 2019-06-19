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

log using "results\logs\interpret_results.log", replace ;


/*********************************************************************************************/
/* INTERPRETATION OF RESULTS FROM CROSS-COUNTRY REGRESSIONS BASED ON CONTEMPORARY VOLATILITY */
/*********************************************************************************************/

use "data\neolithic_country.dta", clear ;

/* ------------------- */
/* COLUMN 1 OF TABLE 1 */
/* ------------------- */

qui reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area africa europe asia americas if samp_cont==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_intermonthly_1901_2000] * 1 + _b[sd_intermonthly_1901_2000_sqr] * (2 * -_b[sd_intermonthly_1901_2000]/(2 * _b[sd_intermonthly_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_intermonthly_1901_2000 if samp_cont==1 ;
di (_b[sd_intermonthly_1901_2000] * r(sd) + _b[sd_intermonthly_1901_2000_sqr] * (2 * -_b[sd_intermonthly_1901_2000]/(2 * _b[sd_intermonthly_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;

/* ------------------- */
/* COLUMN 8 OF TABLE 1 */
/* ------------------- */

qui reg yst sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_frontier_dist abslat area climate axis size plants animals mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_intermonthly_1901_2000] * 1 + _b[sd_intermonthly_1901_2000_sqr] * (2 * -_b[sd_intermonthly_1901_2000]/(2 * _b[sd_intermonthly_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_intermonthly_1901_2000 if samp_cont==1 ;
di (_b[sd_intermonthly_1901_2000] * r(sd) + _b[sd_intermonthly_1901_2000_sqr] * (2 * -_b[sd_intermonthly_1901_2000]/(2 * _b[sd_intermonthly_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;


/*************************************************************************************************************/
/* INTERPRETATION OF RESULTS FROM CROSS-COUNTRY REGRESSIONS BASED ON CONTEMPORARY SEASON-SPECIFIC VOLATILITY */
/*************************************************************************************************************/

/* ---------------------------- */
/* COLUMN 2 OF TABLE 2 [SPRING] */
/* ---------------------------- */

qui reg yst sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_interannual_spr_1901_2000] * 1 + _b[sd_interannual_spr_1901_2000_sqr] * (2 * -_b[sd_interannual_spr_1901_2000]/(2 * _b[sd_interannual_spr_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_interannual_spr_1901_2000 if samp_cont==1 ;
di (_b[sd_interannual_spr_1901_2000] * r(sd) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * -_b[sd_interannual_spr_1901_2000]/(2 * _b[sd_interannual_spr_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;

scalar lo_vol = 0.3081499 ; /* The Republic of Congo */
scalar op_vol = 0.8773901 ; /* Greece */
scalar hi_vol = 1.6036420 ; /* Latvia */

scalar lo_vol_yst = 3000 ; /* The Republic of Congo */
scalar hi_vol_yst = 3700 ; /* Latvia */

/* EFFECT OF MOVING FROM LOW TO OPTIMUM VOLATILITY */
di (_b[sd_interannual_spr_1901_2000] * (op_vol - lo_vol) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * lo_vol + (op_vol - lo_vol)) * (op_vol - lo_vol)) * 1000 ;
/* IMPLIED TRANSITION FOR LOW-VOLATILITY COUNTRY */
di (_b[sd_interannual_spr_1901_2000] * (op_vol - lo_vol) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * lo_vol + (op_vol - lo_vol)) * (op_vol - lo_vol)) * 1000 + lo_vol_yst ;

/* EFFECT OF MOVING FROM HI TO OPTIMUM VOLATILITY */
di (_b[sd_interannual_spr_1901_2000] * (op_vol - hi_vol) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * hi_vol + (op_vol - hi_vol)) * (op_vol - hi_vol)) * 1000 ;
/* IMPLIED TRANSITION FOR HI-VOLATILITY COUNTRY */
di (_b[sd_interannual_spr_1901_2000] * (op_vol - hi_vol) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * hi_vol + (op_vol - hi_vol)) * (op_vol - hi_vol)) * 1000 + hi_vol_yst ;

scalar drop _all ;

/* ---------------------------- */
/* COLUMN 4 OF TABLE 2 [SUMMER] */
/* ---------------------------- */

qui reg yst sd_interannual_sum_1901_2000 sd_interannual_sum_1901_2000_sqr mean_interannual_sum_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_interannual_sum_1901_2000] * 1 + _b[sd_interannual_sum_1901_2000_sqr] * (2 * -_b[sd_interannual_sum_1901_2000]/(2 * _b[sd_interannual_sum_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_interannual_sum_1901_2000 if samp_cont==1 ;
di (_b[sd_interannual_sum_1901_2000] * r(sd) + _b[sd_interannual_sum_1901_2000_sqr] * (2 * -_b[sd_interannual_sum_1901_2000]/(2 * _b[sd_interannual_sum_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;

/* ---------------------------- */
/* COLUMN 6 OF TABLE 2 [AUTUMN] */
/* ---------------------------- */

qui reg yst sd_interannual_aut_1901_2000 sd_interannual_aut_1901_2000_sqr mean_interannual_aut_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_interannual_aut_1901_2000] * 1 + _b[sd_interannual_aut_1901_2000_sqr] * (2 * -_b[sd_interannual_aut_1901_2000]/(2 * _b[sd_interannual_aut_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_interannual_aut_1901_2000 if samp_cont==1 ;
di (_b[sd_interannual_aut_1901_2000] * r(sd) + _b[sd_interannual_aut_1901_2000_sqr] * (2 * -_b[sd_interannual_aut_1901_2000]/(2 * _b[sd_interannual_aut_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;

/* ---------------------------- */
/* COLUMN 8 OF TABLE 2 [WINTER] */
/* ---------------------------- */

qui reg yst sd_interannual_win_1901_2000 sd_interannual_win_1901_2000_sqr mean_interannual_win_1901_2000 ln_frontier_dist abslat area geo_cond bio_cond mean_elev mean_rugg kgatr kgatemp landlocked island africa europe asia americas if samp_cont==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_interannual_win_1901_2000] * 1 + _b[sd_interannual_win_1901_2000_sqr] * (2 * -_b[sd_interannual_win_1901_2000]/(2 * _b[sd_interannual_win_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_interannual_win_1901_2000 if samp_cont==1 ;
di (_b[sd_interannual_win_1901_2000] * r(sd) + _b[sd_interannual_win_1901_2000_sqr] * (2 * -_b[sd_interannual_win_1901_2000]/(2 * _b[sd_interannual_win_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;


/*******************************************************************************************/
/* INTERPRETATION OF RESULTS FROM CROSS-COUNTRY REGRESSIONS BASED ON HISTORICAL VOLATILITY */
/*******************************************************************************************/

/* ------------------- */
/* COLUMN 3 OF TABLE 4 */
/* ------------------- */

qui reg yst sd_interseasonal_1500_1900 sd_interseasonal_1500_1900_sqr mean_interseasonal_1500_1900 ln_frontier_dist abslat area climate axis size mean_elev mean_rugg landlocked europe if samp_hist==1, vce(robust) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_interseasonal_1500_1900] * 1 + _b[sd_interseasonal_1500_1900_sqr] * (2 * -_b[sd_interseasonal_1500_1900]/(2 * _b[sd_interseasonal_1500_1900_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_interseasonal_1500_1900 if samp_hist==1 ;
di (_b[sd_interseasonal_1500_1900] * r(sd) + _b[sd_interseasonal_1500_1900_sqr] * (2 * -_b[sd_interseasonal_1500_1900]/(2 * _b[sd_interseasonal_1500_1900_sqr]) + r(sd)) * r(sd)) * 1000 ;


/*********************************************************/
/* INTERPRETATION OF RESULTS FROM CROSS-SITE REGRESSIONS */
/*********************************************************/

use "data\neolithic_site.dta", clear ;

/* ------------------- */
/* COLUMN 1 OF TABLE 5 */
/* ------------------- */

qui reg uncalc14bp sd_intermonthly_1901_2000 sd_intermonthly_1901_2000_sqr mean_intermonthly_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;

/* METRIC EFFECT AT THE OPTIMUM */
di (_b[sd_intermonthly_1901_2000] * 1 + _b[sd_intermonthly_1901_2000_sqr] * (2 * -_b[sd_intermonthly_1901_2000]/(2 * _b[sd_intermonthly_1901_2000_sqr]) + 1) * 1) * 1000 ;

/* STANDARDIZED METRIC EFFECT AT THE OPTIMUM */
qui sum sd_intermonthly_1901_2000 ;
di (_b[sd_intermonthly_1901_2000] * r(sd) + _b[sd_intermonthly_1901_2000_sqr] * (2 * -_b[sd_intermonthly_1901_2000]/(2 * _b[sd_intermonthly_1901_2000_sqr]) + r(sd)) * r(sd)) * 1000 ;

/* ------------------- */
/* COLUMN 3 OF TABLE 5 */
/* ------------------- */

qui reg uncalc14bp sd_interannual_spr_1901_2000 sd_interannual_spr_1901_2000_sqr mean_interannual_spr_1901_2000 ln_gcayonu latitude europe, vce(cluster code) ;

scalar KleinVol = 1.058640 ;
scalar PrenzVol = 1.234336 ;
scalar KastrVol = 0.945095 ;

/* EFFECT OF MOVING FROM KASTER TO KLEIN DENKTE */
di (_b[sd_interannual_spr_1901_2000] * (KleinVol - KastrVol) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * KastrVol + (KleinVol - KastrVol)) * (KleinVol - KastrVol)) * 1000 ;

/* EFFECT OF MOVING FROM PRENZLAU TO KLEIN DENKTE */
di (_b[sd_interannual_spr_1901_2000] * (KleinVol - PrenzVol) + _b[sd_interannual_spr_1901_2000_sqr] * (2 * PrenzVol + (KleinVol - PrenzVol)) * (KleinVol - PrenzVol)) * 1000 ;

scalar drop _all ;


log close ;
