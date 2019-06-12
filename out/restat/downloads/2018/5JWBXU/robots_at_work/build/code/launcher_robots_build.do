* pull and clean data for "Robots at Work"
* Georg Graetz & Guy Michaels, 12 Feb 2018

cap log close
cd "C:\Users\geogr243\Dropbox\Research\Robots at work\Data archive\build\code"	// set directory
log using "..\..\logs\robots_build.log", replace 

version 15
clear all
set more off

* 1) IFR data
	
	do pull_robots 
		/* 	inputs: 	IFR data (see readme file, see pull_robots.do)
						..\input\IFR\ind_IFR.dta (list of IFR industries) 
						rename_robots_country.do					
			
			outputs: 	..\temp\robots_raw.dta */
	
	do pull_robots_prices_06
		/* 	inputs: 	robot price indices from 2006 World Robotics report
						..\input\IFR\robots_prices_06.xlsx
						
			outputs: 	..\output\robots_prices_06.dta */
	
	do clean_robots
		/* 	inputs: 	..\temp\robots_raw.dta
						clean_robots_adjust_US.do
						clean_robots_impute.do
						clean_robots_stocks.do 
						..\input\IFR\robots_prices_12.dta // prices based on turnover
						rename_robots_industries.do
						labels_robots.do
						
			outputs: 	..\temp\robots_clean.dta */
	
* 2) EUKLEMS data
	
	do pull_EUKLEMS_Mar11
		/* 	inputs: 	..\input\EULKEMS\all_countries_09I.txt
						labels_EUKLEMS_ind.do
						labels_EUKLEMS_var.do
						
			outputs: 	..\temp\EUKLEMS_Mar11.dta */
	
	do pull_EUKLEMS_Mar08_labor
		/* 	inputs: 	..\input\all_labour_input_08I.txt
						labels_EUKLEMS_labor.do
												
			outputs: 	..\temp\EUKLEMS_Mar08_labor */
		
	do pull_EUKLEMS_Mar08_alt // for countries missing from the labor files
		/* 	inputs: 	..\input\all_countries_alt_08I.txt
						
			outputs: 	..\temp\EUKLEMS_Mar08_labor.dta */
	
	do pull_EUKLEMS_Mar08_capital_KOR
		/* 	inputs: 	..\input\EUKLEMS\korea_capital_input_08I.xls
		
			outputs: 	..\temp\EUKLEMS_Mar08_capital_KOR */
		
	do pull_xrates_PWT80 // exchange rates data from Penn World Table
		/* 	inputs: 	..\input\Exchange_rate\pwt80.dta
		
			outputs: 	..\temp\PWT_xrates.dta */ 
		
	do clean_EUKLEMS 
		/* 	inputs: 	..\temp\EUKLEMS_Mar11.dta
						..\temp\EUKLEMS_Mar08_capital_KOR.dta
						..\temp\PWT_xrates.dta
						normalize.do
						xwalk_ind_EUKLEMS_to_robots.do
						rename_robots_industries.do
						labels_EUKLEMS_var_cleaned.do
		
			outputs: 	..\output\EUKLEMS.dta */ 
	
	do clean_EUKLEMS_labor
		/* 	inputs: 	..\temp\EUKLEMS_Mar08_labor.dta
						..\output\EUKLEMS.dta
						
			outputs: 	..\output\EUKLEMS_labor.dta */ 
	
* 3) task measures
		
	do pull_us_census_1980
		/* inputs: 		..\input\IPUMS\usa_00033.dat
						
		   outputs: 	..\temp\us_census_1980.dta */
		
	do pull_DOT_1971
		/* inputs: 		..\input\DOT_1971\07845-0001-Data.dta	
						..\input\Autor-Dorn\occ1970_occ1990dd.dta
						xwalk_occ1990dd-occ1990ddgg.do
						..\input\Autor-Dorn\occ1990dd-occ1990ddgg.dta
						
		   outputs: 	..\temp\DOT_1971.dta */	 	
		   
	do pull_DOT_1991
		/* inputs: 		..\input\DOT_1991\DS0013\06100-0013-Data.txt
						
		   outputs: 	..\temp\DOT_1991_phys_occ3.dta */	 		   

	do clean_DOT_tasks occ1990ddgg
		/* inputs: 		..\temp\DOT_1971.dta	
						..\temp\dot_1991_phys_occ3.dta 
		   
		   outputs: 	..\temp\DOT_tasks.dta */	 

	do clean_DOT_ind_1980
		/* inputs: 		..\temp\us_census_1980.dta	
						..\input\Autor-Dorn\occ1990_occ1990dd.dta
						..\temp\DOT_tasks.dta
						..\input\Autor-Dorn\occ1990dd_task_alm.dta
						..\input\Autor-Dorn\occ1990dd_task_offshore.dta
						..\input\EUKLEMS\xwalk_EUKLEMS-ind1990.dta
						
		   outputs: 	../temp/DOT_tasks_ind */	
		
	do clean_replaceability_occ
		/* inputs: 		..\input\Robot tasks\replaceability_occ_2000.dta 
						..\temp\us_census_1980.dta	
												
		   outputs: 	..\temp\replaceability_occ_1980 */	 
	
	do clean_replaceability_ind 
		/* inputs: 		..\temp\replaceability_occ_1980.dta
						..\input\EUKLEMS\xwalk_EUKLEMS-ind1990.dta 
						
		   outputs: 	..\temp\replaceability_ind */	 	   
		   
* 4) merge component datasets created in steps 1, 2, 3 
	
	do merge_robots_EUKLEMS 
		/* inputs: 		..\temp\DOT_tasks_ind.dta
						..\temp\replaceability_ind.dta
						..\temp\robots_clean.dta
						..\output\EUKLEMS.dta
						unmatched_country-year.do
						unmatched_industry.do
						
		   outputs: 	..\output\tasks_ind.dta
						..\output\robots_EUKLEMS */	
log close 
