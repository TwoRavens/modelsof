/* This file loads data to perform the Spatial HT model for 
 * subdivision open space described in:
 *
 * Abbott, J.K. and Klaiber, H. A. "An Embarrassment of Riches: 
 *      Confronting Omitted Variable Bias and Multi-Scale Capitalization 
 *		in Hedonic Price Models." The Review of Economics and Statistics (2010).
 *
 * Inputs:  HT_data_final.dta -- This file contains both subdivision mean variables
 *				as well as house specific variables for use in the HT estimator.  A
 *				key variable in this file is the spatial identifier subd_id which forms
 *				the basis for the panel estimation technique.
 *
 * Author:  H. Allen Klaiber & Joshua K. Abbott
 * Version:  5-1-2010
*/

/* Set up the working directory which contains the HT Data and the data itself*/
global root_path = "D:\ReStat"
global HT_Data = "HT_data_final.dta";

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/
/* BEGIN PROGRAM HERE - DO NOT MODIFY BELOW THIS POINT 		     */
/***********************************************************************/
/***********************************************************************/
/***********************************************************************/

/* Allow use of semicolon to terminate commands */
#delimit ;

/* Clean up anything left in the workspace prior to starting */
clear;

/* Set up parameters for use in the current stata file */
set memory 1200m;
set more off;

/* Define the log file to store results in */
capture log close;
log using Spatial_HT_ReStat.log, replace;

/*********************************************************
/*Test for exogeneity of instruments in HT specification*/
*********************************************************/

/* Estimate an auxiliary regression with quasi-differenced levels of every variable 
 * AND within transformed tvariables as well.  This allows the possibility of endogeneity in 
 * any of the time varying variables although the goal is to test for such in only a subset.  
 * To avoid making strong random effects efficiency assumptions use cluster robust standard errors.  
 */
 
/* Load the data */
use "$HT_Data", clear;
sort subd_id;

/*Random effects model to get parameters for quasi-demeaning*/
xtreg ln_price sqft lot_acres stories bathrooms year_built has_garage has_pool
	year_built2 acre2 sqft2
	adj_subdOpen adj_lPark adj_cPark adj_school adj_rail adj_canal

	area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3  	

	dum_year_2 dum_year_3 dum_year_4 dum_year_5 
	
	Marea_subdOpen dum_school cPark_cut rPark_cut Mlot_acres  
	Mcbd_phx Mcbd_phx2 
	Mpct_hispanic Mpct_white Mpct_black Mpct_children Mpct_18to35 Mpct_35to55
	if in_sample==1 & region~="nocity", re theta i(subd_id);

bys subd_id: gen T = _N;
gen theta = 1-sqrt(e(sigma_e)^2/(e(sigma_e)^2 + T*e(sigma_u)^2));

sort subd_id;

foreach x of varlist sqft lot_acres stories bathrooms year_built has_garage has_pool
	year_built2 acre2 sqft2 adj_subdOpen adj_lPark adj_cPark adj_school adj_rail adj_canal
     area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3 dum_year_2 dum_year_3 
     dum_year_4 dum_year_5 {;
	
	by subd_id: egen mu_i = mean(`x');
	gen D_`x' = `x'-mu_i;  
	drop mu_i;
	};

gen ones = 1;

foreach x of varlist ln_price ones sqft lot_acres stories bathrooms year_built has_garage has_pool
	year_built2 acre2 sqft2 adj_subdOpen adj_lPark adj_cPark adj_school adj_rail adj_canal
     area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3 dum_year_2 dum_year_3 
     dum_year_4 dum_year_5 
	
	Marea_subdOpen dum_school cPark_cut rPark_cut Mlot_acres
	Mcbd_phx Mcbd_phx2 
	Mpct_hispanic Mpct_white Mpct_black Mpct_children Mpct_18to35 Mpct_35to55 {;
	
	by subd_id: egen mu_i = mean(`x');
	gen QD_`x' = `x'-theta*mu_i;  
	drop mu_i;
	};

/*Test regression*/
regress QD_ln_price QD_ones QD_sqft QD_lot_acres QD_stories QD_bathrooms QD_year_built QD_has_garage QD_has_pool
	QD_year_built2 QD_acre2 QD_sqft2
	QD_adj_subdOpen QD_adj_lPark QD_adj_cPark QD_adj_school QD_adj_rail QD_adj_canal
	QD_area_lPark QD_area_subdOpen1 QD_area_subdOpen2 QD_area_subdOpen3  	
	QD_dum_year_2 QD_dum_year_3 QD_dum_year_4 QD_dum_year_5 

	D_sqft D_lot_acres D_stories D_bathrooms D_year_built D_has_garage D_has_pool
	D_year_built2 D_acre2 D_sqft2
	D_adj_subdOpen D_adj_lPark D_adj_cPark D_adj_school D_adj_rail D_adj_canal
	D_area_lPark D_area_subdOpen1 D_area_subdOpen2 D_area_subdOpen3  	
	D_dum_year_2 D_dum_year_3 D_dum_year_4 D_dum_year_5 

	QD_Marea_subdOpen QD_dum_school QD_cPark_cut QD_rPark_cut QD_Mlot_acres
	QD_Mcbd_phx QD_Mcbd_phx2 
	QD_Mpct_hispanic QD_Mpct_white QD_Mpct_black QD_Mpct_children QD_Mpct_18to35 QD_Mpct_35to55

	if in_sample==1 & region~="nocity", noconstant vce(cluster subd_id);
	
test D_adj_subdOpen = 0;	

/*****************************************************
/* Estimate using Hausman-Taylor estimator           */
/* Estimate assuming all time varying variables are endogenous except as specified.  
 * One non-time varying variable Marea_subdOpen is presumed endogenous as well
 * while other time-constant variables are considered exogenous or as a suite
 * of imperfect proxy variables that may themselves be endogenous  
 * All time varying variables are instrumented by their subdivision de-meaned transformation.
 * Subdivision area of open space is instrumented 
 * by the subdivision means of exogenous time varying characteristics.
 */ 
*****************************************************/

/* Load the data */
cd "$root_path\data\Cleaning Steps";
use "$HT_Data", clear;
sort subd_id;

/*Look at correlation of instruments with endogenous variable(s)*/
corr Marea_subdOpen adj_subdOpen;

/* Set the panel dimension to subdivisions */
xtset subd_id;

/* HT Model with neighborhood controls*/ 
xthtaylor ln_price sqft sqft2 lot_acres acre2 stories bathrooms year_built year_built2
    has_garage has_pool
    dum_year_2 dum_year_3 dum_year_4 dum_year_5 
	adj_subdOpen adj_lPark adj_cPark adj_school adj_rail adj_canal
	area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3  	
	Marea_subdOpen dum_school cPark_cut rPark_cut Mlot_acres  
	Mcbd_phx Mcbd_phx2 
	Mpct_hispanic Mpct_white Mpct_black Mpct_children Mpct_18to35 Mpct_35to55

	if in_sample==1 & region~="nocity", 
	
	endog(sqft sqft2 lot_acres acre2 stories bathrooms year_built year_built2
		has_garage has_pool
		dum_year_2 dum_year_3 dum_year_4 dum_year_5 
		adj_lPark adj_cPark adj_school adj_rail adj_canal
		area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3  	
		Marea_subdOpen
	);


/* Bootstrap to obtain standard errors and save estimates */
set seed 1234;
bootstrap, reps(200) cluster(subd_id) saving("HT_Bootstrap.dta", replace): 
	xthtaylor ln_price sqft sqft2 lot_acres acre2 stories bathrooms year_built year_built2
     has_garage has_pool
     dum_year_2 dum_year_3 dum_year_4 dum_year_5 
     adj_subdOpen adj_lPark adj_cPark adj_school adj_rail adj_canal
     area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3         
     Marea_subdOpen dum_school cPark_cut rPark_cut Mlot_acres  
     Mcbd_phx Mcbd_phx2 
     Mpct_hispanic Mpct_white Mpct_black Mpct_children Mpct_18to35 Mpct_35to55
 
     if in_sample==1 & region~="nocity", 
         
     endog(sqft sqft2 lot_acres acre2 stories bathrooms year_built year_built2
		has_garage has_pool
		dum_year_2 dum_year_3 dum_year_4 dum_year_5 
        adj_lPark adj_cPark adj_school adj_rail adj_canal
        area_lPark area_subdOpen1 area_subdOpen2 area_subdOpen3         
        Marea_subdOpen
     );

*****************************************************/
/* Welfare for HT Model using Bootstrap for Standard Errors*/
/*
 * Point estimates are based on HT run above, not the 
 * average over bootstrap iterations.
 */
*****************************************************/

/* Load the estimation results from the HT Model */
use "HT_Bootstrap.dta", clear;

/* Create average price measures */
gen price_mean = 207679.9;

/* Calculate welfare standard errors using bootstrap to split small and large scale */
gen wHT_small_adj = price_mean*(_b_adj_subdOpen+_b_area_subdOpen1);
gen wHT_small_1000 = price_mean*(_b_area_subdOpen1);
gen wHT_small_2000 = price_mean*(_b_area_subdOpen2);
gen wHT_small_3000 = price_mean*(_b_area_subdOpen3);
gen wHT_large = price_mean*(_b_Marea_subdOpen);

summ wHT_small_adj wHT_small_1000 wHT_small_2000 wHT_small_3000 wHT_large;

/**************/
/* Close logs */
/**************/
capture log close;
