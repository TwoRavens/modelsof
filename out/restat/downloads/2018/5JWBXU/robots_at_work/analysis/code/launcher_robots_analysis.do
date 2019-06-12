* prepare data and perform analysis for "Robots at Work"
* Georg Graetz & Guy Michaels, 12 Feb 2018

cap log close
cd "C:\Users\geogr243\Dropbox\Research\Robots at work\Data archive\analysis\code"	// set directory
log using "..\..\logs\robots_analysis.log", replace 

version 15
clear all
set more off
set matsize 4000
	
* 1) define programs and globals
	global outpath "..\..\figures_and_tables"
		
	global maindataset "..\temp\robots_country-industry_final"
		
	global robotindustries `"( ind_rob!="All other non-manufacturing branches" & ind_rob!="Unspecified" & ind_rob!="All other manufacturing branches" )"'
	global robotcountries `"( country=="AUS" | country=="AUT" | country=="BEL" | country=="DNK" | country=="ESP""'
	global robotcountries `"$robotcountries | country=="FIN" | country=="FRA" | country=="GER" | country=="GRC" | country=="HUN""'
	global robotcountries `"$robotcountries | country=="IRL" | country=="ITA" | country=="KOR" | country=="NLD" | country=="SWE""'
	global robotcountries `"$robotcountries | country=="UK" | country=="US" )"'
	global robotyears `"( year==1993 | year==2007 )"'
	
	global robotsample `"$robotindustries & $robotcountries & $robotyears"'
	
	global weights "share0_rob"
	global se "cluster(country code_euklems)" 
	
	do program_dstats
		
* 2) get input
	local filelist "robots_EUKLEMS EUKLEMS tasks_ind robots_prices_06 EUKLEMS_labor"
		
	foreach file in `filelist' { 
		copy "..\..\build\output/`file'.dta" ..\input\, replace
	}
	
* 3) prep data
	do prep_country
		/* 	inputs: 	..\input\robots_EUKLEMS.dta
						..\input\EUKLEMS.dta
						..\input\EUKLEMS_labor.dta
						
			outputs: 	..\temp\robots_country.dta */
	
	do prep_industry 
		/* 	inputs: 	..\input\robots_EUKLEMS.dta
						..\input\tasks_ind.dta 
						
			outputs: 	..\temp\robots_industry.dta */
	
	do prep_pre
		/* 	inputs: 	..\input\EUKLEMS.dta
						
			outputs: 	..\temp\EUKLEMS_pre.dta */
	
	do prep_country-industry_merge
		/* 	inputs: 	..\input\robots_EUKLEMS.dta 
						..\input\EUKLEMS_labor.dta
						..\temp\robots_country.dta
						..\temp\robots_industry.dta
						..\temp\EUKLEMS_pre.dta 
						
			outputs: 	..\temp\robots_country-industry_merged.dta */
	
	do prep_country-industry_final  
		/* 	inputs: 	..\temp\robots_country-industry_merged.dta
						
			outputs: 	..\temp\robots_country-industry_final.dta */

********************************************************************************			
			
* 4) perform analysis 
	
	do figs_prices // Figure 1	
	do figs_micro // Figure 2
		
	do reg_mainOLS-IV // Table 1, Table A9
	do reg_tfp-prices // Table 2
	do reg_wages // Table 3
	do reg_skills // Table 4
	
	do figs_basic // Figure A1 
	
	do dstats_all // Tables A2, A3 
	do dstats_robots // Table A4
	do reg_fform // Table A5
	do reg_placebo // Table A6
	do reg_tasks // Table A7 
	do reg_mainRobust // Table A8 
	do counterfactuals 0.35 // Table A10 

macro drop _all
cap log close
