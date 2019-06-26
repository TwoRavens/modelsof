capture log close
log using _LogfinalAnalysis.log, replace

********************************************************************************
*
*DoFile for complete analysis of:
*
*"Anticipating mediated talks  
*Predicting the timing of mediation with  
*disaggregated conflict dynamics"
*
*Constantin Ruhe, University of Konstanz
*
********************************************************************************
 

clear

*setting a seed taken from random.org
set seed 977938

*please make sure you specify the correct working directory
local w_dir "Z:\PhD\Paper 1\__JPR_submission\SubmissionFinal\ReplicationMaterial\RunAnalysis"

*please specify where R is installed on your computer. you also need to install 
* the "foreign" package in R. 
*NOTE: The original analysis was run on R 2.14.2
global R_dir "C:\Program Files\R\R-2.14.2\bin\R.exe"

set more off
cd "`w_dir'"
use "GED_MILC_final_ 8 May 2014.dta"

*declare as panel data
xtset dyad_unique month


*create variables needed for analysis
do 1_create_vars.do

*save as data for the analysis
save "data_full", replace
global data "data_full.dta"



********************************************************************************
** RESULTS AND FIGURES REPORTED IN THE PAPER


*run principle models 
*Table 1 [AS SHOWN IN PAPER]
do 2_core_analysis.do


*create graphs to enable accessible interpretation of interaction term
*Figure 1 [AS SHOWN IN PAPER]
do 3_graphs.do


*generating graphic of joint effect on Pr(Mediation) 
*Figure 2 [AS SHOWN IN PAPER]
do 4_joint_effect.do


*generate time series graphs of predicted probabilities 
*Figure 3 [SHOWN IN PAPER; REMAINING FIGURES IN WEB APPENDIX]
do 5_prediction_time_series.do


*model fit using prediction 
*Figure 4 [SHOWN IN PAPER; REMAINING FIGURES IN WEB APPENDIX]
do 6_predictive_power.do




********************************************************************************
** RESULTS AND FIGURES REPORTED IN THE WEB APPENDIX


*show effect at different lags 
do 7_alternativeLagsGraphs.do


* ...and with more flexible functional form of interaction
do 8_alternativeLagsPolynomialGraphs.do


*demonstrate robustness when controlling for heterogeneity
do 9_heterogeneity.do


*graphical robustness check of interaction effect when estimated using 
*conditional fixed effects logit
do 10_fe_graphs.do


*compare results against alternative duration models for repeated events
do 11_duration_models.do


*show that inverted u-shaped pattern holds even with non-parametric regression
do 12_loess.do


*show that estimated pattern does not depend on individual case
do 13_jackknife.do


*generate correlation table
do 14_corrtable.do


*compare predicted probabilies of model w/ and w/o interaction term
do 15_interaction_predicted_probability.do


*using distance to major city as alternative to capital distance
do 16_city_distance_alternative


*create graphs to enable accessible interpretation of interaction term
do 17_graph_city_distance_alternative



log close
