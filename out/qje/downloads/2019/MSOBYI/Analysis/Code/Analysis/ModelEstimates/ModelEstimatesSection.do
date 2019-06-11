/* ModelEstimatesSection.do */
* This is the master file for all Stata analysis done in the model estimates section.




/* Export the data for Matlab model estimation*/
include Code/Analysis/ModelEstimates/export_for_matlab_iv.do


/* Examine First Stage Regression of our price instrument*/
include Code/Analysis/ModelEstimates/explore_iv.do


/* Examine Variation in Instrument by Department*/
include Code/Analysis/ModelEstimates/iv_variation_plot.do

*** NOW GO TO MATLAB AND RUN MatlabMasterFile.m ***



/* Import Matlab Model Estimates and Setup Data for Health Index Decomposition*/
include  Code/Analysis/ModelEstimates/health_index_decomp.do

/* Perform Decomposition*/
include Code/Analysis/ModelEstimates/estimate_decom_gmm_iv.do





