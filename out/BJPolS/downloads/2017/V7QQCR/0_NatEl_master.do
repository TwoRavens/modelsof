*********************************************************************
* Negotiating under political uncertainty (Kleine & Minaudier 2016) *
*********************************************************************

*Copy the dataset and all do files into the current working directory then
*run this file to reproduce the results.

/* 
Note: certain regression require several hours to run, due to the estimation method and the large size of the dataset.
Regressions 1 and 4 in the robustness tests in particular may take more than a day to complete, depending on computer specifications.
*/
				  
*********************************************************************
// Files Needed :
*	1. 1_NatEl_dataset.do (Addition of election data to parliamentary dataset)
*	2. 2_NatEl_regression_main.do (main regression)
*	3. 3_coeff_graph.do (main regression)
*	4. 4_NatEl_regression_robust.do (robustness tests presented in online appendix)
*	5. 5_NatEl_continuous_dataset.do (revision to dataset used for one of the robustness tests presented in online appendix)
*	6. eup-10-0520-File005.dta (Dataset)
*	7. Demographic_data_Eurostat.xls (Population data)
*	8. Voting_weights.xls (Voting weights data)
*	9. GDP_IMF.xlsx (Economic data)
*	10. The Timeline of Elections - A Comparative Perspective.dta (for robustness test using polling data)

*********************************************************************
*Output Files:
*	1. EULO_NATEL.dta (Dataset with elections variables)
*	2. NATEL_output.dta (Dataset with coefficients and data for graphs)
*	3. NatEl_output_robust.dta ((Dataset with coefficients from robustness tests)
*	4. Results.txt (Log of data compilation and results of all regressions)
*	5. Graph2large.gph (Coefficients for large countries)
*	6. Graph2small.gph (Coefficients for small countries)
*	7. Graph2large.png (Coefficients for large countries)
*	8. Graph2small.png (Coefficients for small countries)
**********************************************************************

clear
version 14

mkdir Output
log using "Output\Results.log", name("Results") replace 

***********************************
*Add election variables to dataset* 
***********************************

do 1_NatEl_dataset.do

*********************
*Run main regression*
*********************

do 2_NatEl_regression_main.do

*************
*Draw Graphs*
*************

do 3_coeff_graph.do

**********************
*Run robustness tests*
**********************

do 4_NatEl_regression_robust.do












