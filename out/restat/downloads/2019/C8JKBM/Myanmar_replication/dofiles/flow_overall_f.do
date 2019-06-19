// Analysis using garment and food processing industries survey 2013-2015. 
global replication "/Users/maritanaka_pro/Library/Mobile Documents/com~apple~CloudDocs/Projects/Myanmar/Myanmar_replication" 

global dofile "$replication/dofiles" 
global root "$replication/data"  
global results "$replication/results"

global jetro "/Users/maritanaka_pro/Library/Mobile Documents/com~apple~CloudDocs/Projects/Myanmar/Analysis/Kudo_jetro" 

// Construct variables from original data ********************************************
*** Garment 
run "$dofile/makevar_f.do" // input = "panel_basic.dta", output="panel_basic_var.dta"

*** Food 
run "$dofile/makevar_food_f.do" // input = "panel_basic_food", output = "myanmar_food_analysis.dta"

// Main  **********************************************************************
*** Figure 1. export volume
run "$dofile/figure1_export_f.do"  // input = "comtrade_trade_dataMyanmar2015hs6162.xlsx"

*** Table 2. Figure 2. airport IV, cross-section
run "$dofile/analysis_airport_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table 3. Figure 2. airport, changes in outcomes
run "$dofile/analysis_airport_dynamic_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table 4. Food. airport placebo test 
run "$dofile/analysis_airport_withfood_f.do"  // input = "myanmar_food_analysis.dta"

*** Table 6. woven IV, cross-section 
run "$dofile/analysis_woven_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table 7. Garment vs Food, first difference 
run "$dofile/analysis_dynamics_withfood_f.do"  // input = "myanmarpanel_analysis.dta", "myanmar_food_analysis.dta"

// Appendix - data *******************************************************************
*** Figure A.1.1. Histogram of working conditions
run "$dofile/graph_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table A.1.5. Table A.1.6. Summary statistics 
run "$dofile/samplestats_f.do" // input = "myanmarpanel_analysis.dta"

*** Table A.1.7. A.1.8 Plant observation data 
run "$dofile/checkscore_observation_f.do"  // input = "myanmarpanel_analysis.dta"

// Appendix - airport IV *************************************************************
*** Table B.1.2. Panel B. (linear airport time)
*** Table B.1.3. columns (1)-(3). (details of score) 
*** Table B.1.4. z-score (1)-(2)
*** Table B.1.5. restricting samples Panel A,B. 
run "$dofile/analysis_airport_f.do" // input = "myanmarpanel_analysis.dta"

*** Table B.1.3. columns (4)-(6). (details of score) 
*** Table B.1.4. z-score (3)-(4)
*** Table B.1.5. restricting samples Panel C,D. 
*** Table B.1.6. OLS changes in outcomes 
run "$dofile/analysis_airport_dynamic_f.do" // input = "myanmarpanel_analysis.dta"

// Appendix - Woven IV ***********************************************************
*** Table B.2.2. DID specification with woven IV - 2004-2015, 
*** Table B.2.3. PSM using information in 2004 
run "$jetro/did_woven_ap_f.do"  // input = "myanmarpanel_analysis.dta", "jetroide2005_working.dta" (JETRO data)

*** Table B.2.4. Woven IV and airport IV - Hansen J 
run "$dofile/analysis_2IVs_f.do" // input = "myanmarpanel_analysis.dta"

// Appendix - others **************************************************************

*** Table B.3.1. OLS
run "$dofile/analysis_ols_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table B.3.3. decomposition
run "$dofile/decomposition_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table B.3.4. simple panel fixed effects
run "$dofile/analysis_panelfe_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table B.3.5. comparison of domestic vs fdi 
run "$dofile/analysis_fdi_domestic_f.do"  // input = "myanmarpanel_analysis.dta"

*** Table B.3.6-8, selection, reweighting, bound estimates for attrition issues 
run "$dofile/bounds_f.do" // input = "myanmarpanel_analysis.dta", "jetroide2005_working.dta" (JETRO data)

// JETRO data ******************************************************************************
run "$dofile/jetroide2005_f.do" // make the analysis variables, input = "Data_(1-143 revised by Kudo, operating basis).xlsx", "geo_jetro.xlsx",
// output =  "jetroide2005_working.dta"

*** Yable 1, Table 5, Table B.1.2., Table B.1.1., B.2.1. 
run "$dofile/jetro_analysis_f.do" // input = "jetroide2005_working.dta"
