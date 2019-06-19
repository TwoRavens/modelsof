**************************************************************************************************************
*			Boot-strap Routine for Generating Figure  5 Quantile Price Difference Analysis					 *
* 			Note: This program uses a bootstrap routine to obtain quantile and OLS estimates
*				  and standard errors for Figure 5.  Setps 1-4 below generate 200 bootstrap 
*				  estimates with regressions run separately for each car type.  The standard
*				  errors are obtained by taking the weighted average across car types over 
*				  these 200 iterations. The point estimates are obtained in steps 5 - 8 and
*				  are based on a weighted average across car types of estiamtes using the full
*				  observed sample for that car type.  
**************************************************************************************************************



clear
clear matrix 
capture log close
set matsize 5000


**************************************************************************************************************
*			Load the data and do initial data cleaning steps							 					 *
**************************************************************************************************************

// LOAD DATA -- CHANGE THE PATH AS NEEDED

cd //REDACTED//


// Load the dataset saved in the full_analysis .do file.  This is the final regression sample
use regdataset_final.dta 

// Keep only the variables needed for this analysis
keep price_sale jap sold miles miles2 miles3 sold make model body model_year year auction carid2


// Save a copy of the dataset with only the needed variables
save regdataset_restr_final.dta, replace 


**************************************************************************************************************
*			Step 1: 200 BOOTSTRAP REPETITIONS TO GENERATE S.E.'S FOR SQREG'S							 	 *
**************************************************************************************************************

clear
capture log close

// Log file will hold the results as text
log using results_bsampleQreg_final.log, replace

forvalues i=1(1)200	{  
	
	// Open the regression data set reduced to useable variables.  
	use regdataset_restr_final.dta, clear 
	
	// Obtain the number of observations in the dataset and draw a bootstrap sample
	qui sum sold
	local num=r(N)
	set seed 4444`i'     // Note: we set the same seed through thte do file that varies by iteration.
	bsample (`num') 
	
	// Restrict to car types (make model body model_year year auction) with at least 20 sold observations
	cap gen temp5 = 1 if sold == 1
	cap bys carid2: egen n2 = count(temp5)
	cap drop if n2 < 20 
	// Generate a new car-type id that will have consecutive numbering useful for loop below
	egen carid2_new = group(make model body model_year year auction) 
	
	// Obtain the number of unique carids for the limits of the loop below
	cap sum carid2_new	
	local max= r(max) 
	
	// Run the simultaneous quantile regression separately for each carid
	forvalues carid = 1(1)`max'	{
		preserve 
		cap keep if carid2_new==`carid' 
		cap sum carid2
		local cc = r(min) // Local variable to track original carid2 so we can compare across samples 
		capture sqreg price_sale jap miles miles2 miles3, q(.1 .25 .5 .75 .9) reps(2)
		mat b=e(b)
		// Display the results so they are captured as text in the log file
		capture noisily display as text  `carid', `cc', `i', 	b[1,1], b[1,6], b[1,11], b[1,16], b[1,21], e(N)
		restore
	}
		
}
cap log close


**************************************************************************************************************
*			Step 2: Using txt file with results from step 1 create the weighted average					 	 *
**************************************************************************************************************

log using sqreg_se_bsample_final.log, replace

// This step reads in a text file with the results from Step 1.  That text file is simply a cleaned version
//      of the log-file output from step 1.  
insheet using bs_sqreg_results.txt, delimiter(" ") clear

rename v1 carid2_new
rename v2 carid2
rename v3 rep
rename v4 beta10
rename v5 beta25
rename v6 beta50
rename v7 beta75
rename v8 beta90
rename v9 nob

// For each quantile cut in the quantile regressions, trim out the top and bottom 1% outliers
//		This step is useful simply because a few iterations will draw samples that produce
//   	divergent results.  
foreach q in 10 25 50 75 90	{
	//Identify outlier estimates
	egen p1_`q' = pctile(beta`q'), p(0.1)
	egen p99_`q' = pctile(beta`q'), p(99.9)

	//Drop outlier estimates 
	drop if beta`q'<p1_`q'
	drop if beta`q'> p99_`q'
	
	//For remaining estimates get a variable weighting the estimate by number of car-type obs
	gen weighted_e`q' = beta`q'*nob
}

// Get the sum of the weighted estimates for each quantile cut
collapse (sum) weighted_e10 weighted_e25 weighted_e50 weighted_e75 weighted_e90 nob, by(rep)

// Calculate the weighted average estimate by dividing by total number of observations
//		The standard deviation of the weighted estimate is the bootstrap estimate of 
//		the standard error of the estimate we use in Figure 5.
foreach q in 10 25 50 75 90	{
	gen estimate`q' = weighted_e`q'/nob
	qui sum estimate`q'
	local se = r(sd)
	capture noisily display as text `q', `se'
}



cap log close


**************************************************************************************************************
*			Step 3: Repeat Step 1 but now for OLS esimtates 											 	 *
**************************************************************************************************************


clear
capture log close

// Log file will hold the results as text
log using results_bsampleOLS_final.log, replace

forvalues i=1(1)200	{  
	// Open the regression data set reduced to useable variables. 
	use regdataset_restr_final.dta, clear
	
	// Obtain the number of observations in the dataset and draw a bootstrap sample
	qui sum sold
	local num=r(N)
	set seed 4444`i' // Seed is same as in Step 1 to ensure consistent sample comparison between sqreg and ols
	bsample (`num') 
	
	// Restrict to car types (make model body model_year year auction) with at least 20 sold observations
	cap gen temp5 = 1 if sold == 1
	cap bys carid2: egen n2 = count(temp5)
	cap drop if n2 < 20 
	// Generate a new car-type id that will have consecutive numbering useful for loop below
	egen carid2_new = group(make model body model_year year auction) 
	
	// Obtain the number of unique carids for the limits of the loop below
	cap sum carid2_new
	local max= r(max)
	
	// Run the OLS regression separately for each carid
	forvalues carid = 1(1)`max'	{
		preserve 
		cap keep if carid2_new==`carid' 
		cap sum carid2
		local cc = r(min) // Local variable to track original carid2 so we can compare across samples
		capture reg price_sale jap miles miles2 miles3 
		// Display the results so they are captured as text in the log file
		capture noisily display as text  `carid', `cc', `i', _b[jap], e(N)
		restore
	}
		
}

cap log close

**************************************************************************************************************
*			Step 4: Repeat Step 2 above for the OLS 													 	 *
**************************************************************************************************************

log using reg_se_bsample_final.log, replace

// This step reads in a text file with the results from Step 3.  That text file is simply a cleaned version
//      of the log-file output from step 3.  

insheet using bs_ols_results.txt, delimiter(" ") clear

rename v1 carid2_new
rename v2 carid2
rename v3 rep
rename v4 beta
rename v5 nob
sort rep carid2_new

// Remove outliers of estimates above and below the .1 and 99.9 percentile
//		This step is useful for dealing with divergent estimates generated in some
//		small bootrstrap samples.
drop if beta==0 // This removes observations for samples where OLS estimates did not generate
egen p1 = pctile(beta), p(0.1)
egen p99 = pctile(beta), p(99.9)
drop if beta<p1
drop if beta> p99

//For remaining estimates get a variable weighting the estimate by number of car-type obs
gen weighted_e = beta*nob

// Get the sum of the weighted estimates 
collapse (sum) weighted_e nob, by(rep)

// Calculate the weighted average estimate by dividing by total number of observations
//		The standard deviation of the weighted estimate is the bootstrap estimate of 
//		the standard error of the estimate we use in Figure 5.
gen estimate= weighted_e/nob
qui sum estimate
local se = r(sd)
capture noisily display as text "ols", `se'

cap log close


**************************************************************************************************************
*			Step 5: Generate the point estimates for SQREG  											 	 *
**************************************************************************************************************

clear

// Log file will hold the results as text
log using sqreg_point_final.log, replace

// Open the regression data set reduced to useable variables. 
use regdataset_restr_final.dta

// Restrict to car types (make model body model_year year auction) with at least 20 sold observations
gen temp5 = 1 if sold == 1
bys carid2: egen n2 = count(temp5)
drop if n2 < 20
// Generate a new car-type id that will have consecutive numbering useful for loop below
egen carid1_new = group(make model body model_year year auction)

// Obtain the number of unique carids for the limits of the loop below
sum carid1_new
local max= r(max)

// Run the simultaneous quantile regression separately for each carid	
forvalues carid = 1(1)`max'	{
	capture sqreg price_sale jap miles miles2 miles3 if carid1_new==`carid', q(.1 .25 .5 .75 .9) reps(2)
	mat b=e(b)
	// Display the results so they are captured as text in the log file
	capture noisily display as text  `carid', 	b[1,1], b[1,6], b[1,11], b[1,16], b[1,21], e(N)
}
	
**************************************************************************************************************
*			Step 6: Generate the weighted averages of piont estimates for quantile regs					 	 *
**************************************************************************************************************

cap log close

log using sqreg_est_full_final.log, replace

// This step reads in a text file with the results from Step 5.  That text file is simply a cleaned version
//      of the log-file output from step 5.  
insheet using sqregpointest_final.txt, delimiter(" ") clear

rename v1 rep
rename v2 beta10
rename v3 beta25
rename v4 beta50
rename v5 beta75
rename v6 beta90
rename v7 nob

// Remove outliers of estimates above and below the .1 and 99.9 percentile
//		This step is useful for dealing with divergent estimates generated in some
//		small carid samples.
foreach q in 10 25 50 75 90	{

	//Identify outlier estimates
	egen p1_`q' = pctile(beta`q'), p(0.1)
	egen p99_`q' = pctile(beta`q'), p(99.9)

	//Drop outlier estimates 
	drop if beta`q'<p1_`q'
	drop if beta`q'> p99_`q'
	
	//For remaining estimates get a variable weighting the estimate by number of car-type obs
	gen weighted_e`q' = beta`q'*nob
}

// Get the sum of the weighted estimates for each quantile cut
collapse (sum) weighted_e10 weighted_e25 weighted_e50 weighted_e75 weighted_e90 nob

// Calculate the weighted average estimate by dividing by total number of observations
// 		The point estimate is this weighted average for each quantile
foreach q in 10 25 50 75 90	{
	gen estimate`q' = weighted_e`q'/nob
	qui sum estimate`q'
	local point_est = r(mean)
	capture noisily display as text `q', `point_est'
}
	
cap log close	

**************************************************************************************************************
*			Step 7: Generate the point estimates for OLS	  											 	 *
**************************************************************************************************************		

// Log file will hold the results as text
log using olsreg_point_final.log, replace

// Open the regression data set reduced to useable variables. 
use regdataset_restr_final.dta

// Restrict to car types (make model body model_year year auction) with at least 20 sold observations
gen temp5 = 1 if sold == 1
bys carid2: egen n2 = count(temp5)
drop if n2 < 20
// Generate a new car-type id that will have consecutive numbering useful for loop below
egen carid1_new = group(make model body model_year year auction)

// Obtain the number of unique carids for the limits of the loop below
sum carid1_new
local max= r(max)

// Run the OLS regression separately for each carid	
forvalues carid = 1(1)`max'	{

	capture reg price_sale jap miles miles2 miles3 if carid1_new==`carid'  
	// Display the results so they are captured as text in the log file
	capture noisily display as text  `carid', _b[jap], e(N)
		
}
		

cap log close

**************************************************************************************************************
*			Step 8: Generate the weighted average of OLS point estimates	  							 	 *
**************************************************************************************************************	

log using olsreg_est_full_final.log, replace

// This step reads in a text file with the results from Step 7.  That text file is simply a cleaned version
//      of the log-file output from step 7.  
insheet using olsregpointest_final.txt, delimiter(" ") clear

rename v1 carid
rename v2 beta
rename v3 nob

// Remove outliers of estimates above and below the .1 and 99.9 percentile
//		This step is useful for dealing with divergent estimates generated in some
//		small carid samples.

drop if beta==0 // This removes observations for samples where OLS estimates did not generate
egen p1 = pctile(beta), p(0.1)
egen p99= pctile(beta), p(99.9)
drop if beta<p1
drop if beta> p99

//For remaining estimates get a variable weighting the estimate by number of car-type obs
gen weighted_e = beta*nob

// Get the sum of the weighted estimates
collapse (sum) weighted_e nob

// Get the final piont estimate by dividing by the number of observations
gen estimate= weighted_e/nob

qui sum estimate
local point_est = r(mean)
capture noisily display as text "ols", `point_est'

cap log close


**************************************************************************************************************
*			Run our standard regression framework on similar sample for comparison  					 	 *
**************************************************************************************************************	
/*COMPARE WITH REGRESSION RESULTS*/

log using reg_bscomparison.log, replace

use regdataset_restr_final.dta, clear

gen temp5 = 1 if sold == 1
bys carid2: egen n2 = count(temp5)

areg price_sale jap miles miles2 miles3 agem* if n2 >= 20, absorb(carid2) cluster(carid3)

capture log close


