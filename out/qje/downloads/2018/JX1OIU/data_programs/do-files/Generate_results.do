*** This file generates all tables and figures in the paper by calling various do-files


* Define vectors of controls
global controls_country "ln_time_obs_ea small_scale"
global controls_country_drop "small_scale"
global controls_country_migrant "corigin_ln_time_obs_ea corigin_small_scale"
global controls_country_migrant_drop "corigin_small_scale"
global controls_ind "i.age female"
global controls_ind_drop "*age"
global controls_ethnic "ln_time_obs_ea_e small_scale"
global controls_ethnic_drop "small_scale"
global controls_history_origins "ln_time_obs_ea"
global controls_history "ln_time_obs_ea"
global controls_history_drop ""



* EA analyses
run Data_programs/Do-files/EA/Table_3.do
run Data_programs/Do-files/EA/Table_4.do
run Data_programs/Do-files/EA/Table_5.do
run Data_programs/Do-files/EA/Figures_2_3.do
run Data_programs/Do-files/EA/Figure_4.do
run Data_programs/Do-files/EA/Table_11.do



* Cross-country analyses and corresponding within-country results
run Data_programs/Do-files/Country/Tables_6_7_9_10.do
run Data_programs/Do-files/Country/Figure_5.do
run Data_programs/Do-files/Country/Figures_6_8.do
run Data_programs/Do-files/Country/Figure_9.do



* MFQ migrant analyses
run Data_programs/Do-files/MFQ/Table_8.do
run Data_programs/Do-files/MFQ/Figure_7.do


