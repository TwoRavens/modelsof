


clear all
set more off
capture log close

set maxvar 10000
set matsize 10000

**************************set filepath here*************************************

global filepath "/Users/`c(username)'/Dropbox/Poverty and Mental Health/Replication files"

*********************set subdirectories automatically **************************

global data  	"$filepath/data"
global temp 	"$data/temp/" // This is where temporary data files are stored
global dofiles  "$filepath/do-files"
global output  	"$filepath/output"
global tables  	"$filepath/output/tables"
global figures  "$filepath/output/figures"


*********************** Start log file *****************************************
log using "$filepath/suicide_logfile", replace

*********************set path to ado-file folder here***************************
adopath ++ "$filepath/ado-files/"

********************************************************************************
**********************generate the final datasets*******************************
********************************************************************************

/*
There are the following data-generating do-files.
Before running the do-files, one needs to adjust the file paths in "generate_podes.do"
and "generate_IFLS.do" to point to local versions of the raw data which we cannot 
include for legal reasons.
*/



*do "$filepath/do-files/generate_datasets/generate_podes.do" // Generate main PODES data set
*do "$filepath/do-files/generate_datasets/generate_podes_06borders.do" // Generate 2006 borders PODES data set
*do "$filepath/do-files/generate_datasets/generate_IFLS.do" // Generate IFLS data set

********************************************************************************
********************************************************************************
**********************Generate outputs *****************************************
********************************************************************************
********************************************************************************

********************************************************************************
**********************Main tables***********************************************
********************************************************************************

do "$dofiles/generate tables/Table1_summarystats.do"
do "$dofiles/generate tables/Table2_rolloutmain.do"
do "$dofiles/generate tables/Table3_RCTmain.do"
do "$dofiles/generate tables/Table4_interactionrainfallcash.do"
do "$dofiles/generate tables/Table5_IFLSmain.do"


**********************Appendix tables*******************************************

do "$dofiles/generate tables/TableA1_correlates_suicides.do"
do "$dofiles/generate tables/TableA2_balance.do"
do "$dofiles/generate tables/TableA3_identcheck.do"
do "$dofiles/generate tables/TableA4_rollout_alternativeoutcomes1.do"
do "$dofiles/generate tables/TableA5_rollout_alternativeoutcomes2.do"
do "$dofiles/generate tables/TableA6_rollout_droppartials.do"
do "$dofiles/generate tables/TableA7_rolloutmain_noweights.do"
do "$dofiles/generate tables/TableA8_rolloutmain_2006borders.do"
do "$dofiles/generate tables/TableA9_rollout_addrobust.do"
do "$dofiles/generate tables/TableA10_RCTadditionaloutcomes1.do"
do "$dofiles/generate tables/TableA11_RCTadditionaloutcomes2.do"
do "$dofiles/generate tables/TableA12_RCTmain_droppartials.do"
do "$dofiles/generate tables/TableA13_RCTmain_noweights.do"
do "$dofiles/generate tables/TableA14_RCTmain_2006borders.do"
do "$dofiles/generate tables/TableA15_RCTmain_addrobust.do"
do "$dofiles/generate tables/TableA16_dynamics.do"
do "$dofiles/generate tables/TableA17_dynamics_noweights.do"
do "$dofiles/generate tables/TableA18_intensity.do"
do "$dofiles/generate tables/TableA19_interactionrainfallcash_noweights.do"
do "$dofiles/generate tables/TableA20_rainfallsymmetric.do"
do "$dofiles/generate tables/TableA21_rainfallinteraction_shocks.do"
do "$dofiles/generate tables/TableA22_rain_detrend.do"
do "$dofiles/generate tables/TableA23_rain_detrend_noweights.do"
do "$dofiles/generate tables/TableA24_IFLS_interaction.do"
do "$dofiles/generate tables/TableA25_IFLS_descriptives.do"
do "$dofiles/generate tables/TableA26_rollout_endogenouscontrols.do"
do "$dofiles/generate tables/TableA27_hetero.do"


********************************************************************************
**********************Main figures**********************************************
********************************************************************************

do "$dofiles/generate figures/Figure1_eventstudy.do"
do "$dofiles/generate figures/Figure2_eventstudy_dynamic.do"
do "$dofiles/generate figures/Figure3_nonpar_rainfall_suiciderate.do"


**********************Appendix figures******************************************

do "$dofiles/generate figures/FigureA1_meansovertime.do"
do "$dofiles/generate figures/FigureA2_meansovertime_noweights.do"
do "$dofiles/generate figures/FigureA3_eventstudy_noweights.do"
do "$dofiles/generate figures/FigureA4_rct_eventstudy.do"
do "$dofiles/generate figures/FigureA5_rct_eventstudy_norm2000.do"
do "$dofiles/generate figures/FigureA6_meansovertime_poisson.do"
do "$dofiles/generate figures/FigureA7_eventstudy_poisson.do"


********************************************************************************
**********************Additional do-files **************************************
********************************************************************************

do "$dofiles/additional do-files/Effect_size_calcs.do" // Effect size calculations for Online Appendix
do "$dofiles/additional do-files/Equality_of_impact.do" // Test for equality of rainfall and CCT
do "$dofiles/additional do-files/Treatment_volume.do" // Calculations of treatment volumes

********************************************************************************
********************************************************************************
********************************************************************************
log close
