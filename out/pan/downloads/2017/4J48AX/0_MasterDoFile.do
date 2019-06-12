capture log close
log using _LogFile.log, replace
cd "C:\Users\Constantin\bwSyncAndShare\Paper\Paper_EncoreBarcelona\PA_SubmissionFinal\Analysis\ReplicationMaterial"


set more off
eststo clear


set seed 44129610 // acquired from random.org on 2017-06-27 14:56:39 UTC



*********************************************************
* Plot example graph -> NOT part of the empirical example
do 1_ExampleGraph.do



***
*
* Empirical replication of Beardsley (2011)
*
***


**********************************************
* non-parametric hazard and survival estimates
do 2_NonParametric.do



*********************************************************
* Cox models and tests of porportional hazards assumption
do 3_Cox.do



******************
* generate Table 1 
do 4_Tables.do



*************************************************
* Calculate survivor function from original model
do 5_SurvivalOriginal.do



**************************************************
* Calculate survivor function for restricted model
do 6_SurvivalRestricted.do


*****************************************
* combine individual graphs in one figure
do 7_PlotResults.do



********************
* Royton-Pamar model 
do 8_RoystonParmar.do



*****************************************************************************
* Calculate survivor function for restricted model (scurve_tvc and R-P model)
do 9_PlotCoxRoystonParmar.do



*****************************************
* combine individual graphs in one figure
do 10_PlotResultsWithRoystonParmar.do



***
*
* Monte Carlo Simulation of Survival Estimates
*
***

************************************************
** !!! The following do-files may take several
** hours to run !!!
************************************************


************************************************
* run Monte Carlo simulation w/ 500 observations
do 11_Simulation.do



***********************************************
* run Monte Carlo simulation w/ 50 observations
do 12_Simulation_obs50.do



***********************************************
* run Monte Carlo simulation w/ 50 observations
do 13_Simulation_obs200.do




***********************************************
* Additional results based on reviewer requests
* Results are documented in the web appendix
* Numbers indicate which original analyis is 
* checked or augmented:
do 1a_ExampleGraph_flatbaseline.do // <- flat baseline example in web appendix
do 6a_SurvivalRestricted_hypothetical_late_mediation.do // <- hypothetical case with mediation as time-varying covariate after 1.5, described in web appendix
** !!! the bootstrap procedure may take a long time to run !!!
do 6b_SurvivalDiffRestricted_BootstrappedCIs.do // <- bootstrap confidence intervals for difference in survival curves
do 10a_discrete_survival_Beardsley.do // <- estimating discrete duration model and corresponding survival curves



log close


