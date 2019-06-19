/*This main file runs the Probit from Inter-Industry Strategic R&D.
Assumes the working directory has already been set.

Andrew C. Chang
University of California, Irvine
June 30, 2010
v. 1.00 - Original Implementation

*/

clear all  //clear memory
capture log close
log using RDPaper_IsGcause.log, replace
set memory 50m
set matsize 800
set more off

insheet using IsGcause.txt  //is_gcause, is_highdds

//Create intra and inter regressors, these are interaction variables of max_dds and indicators for inter/intra industry links
generate max_dds_inter = 0
replace max_dds_inter = max_dds if isintradummy == 0

generate max_dds_intra = 0
replace max_dds_intra = max_dds if isintradummy == 1

//Table 4.1, column(1) industry-specific controls
probit is_gcause_ind max_dds_inter max_dds_intra, vce(robust) 
margins, dydx(*)
//Table 4.1, column(1) aggregate controls
probit is_gcause_agg max_dds_inter max_dds_intra, vce(robust) 
margins, dydx(*)

//Table 4.1, column(2), industry-specific controls
probit is_gcause_ind max_dds_inter max_dds_intra if (isalldummy == 0), vce(robust) 
margins if (isalldummy == 0), dydx(*)
//Table 4.1, column(2), aggregate controls
probit is_gcause_agg max_dds_inter max_dds_intra if (isalldummy == 0), vce(robust) 
margins if (isalldummy == 0), dydx(*)

//linear probability model
//Table 4.2, column (1), industry-specific controls
regress is_gcause_ind max_dds_inter max_dds_intra, vce(robust)

//Table 4.2, column (1), aggregate controls
regress is_gcause_agg max_dds_inter max_dds_intra, vce(robust)

//Table 4.2, column (2), industry-specific controls
regress is_gcause_ind max_dds_inter max_dds_intra if isalldummy == 0, vce(robust)

//Table 4.2, column (2), aggregate controls
regress is_gcause_agg max_dds_inter max_dds_intra if isalldummy == 0, vce(robust)


log close



