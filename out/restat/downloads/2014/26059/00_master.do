
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* MASTER DOFILE
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the do files here 
*** or leave "." if the do files are in the current directory 

global do_master "."


* 1. Read and process data from SHARE wave 1

do "$do_master/01_share_wave1.do"


* 2. Read and process data from SHARE WAVE 2

do "$do_master/02_share_wave2.do"


* 3. Read and process data from SHARE WAVE 3

do "$do_master/03_share_wave3.do"


* 4. Merge data from SHARE waves 1-3

do "$do_master/04_merge_SHARE.do"

	* 4.1 RUN GDP DOFILE
	do "$do_master/04_external_gdp.do"

	* 4.2 RUN COMBAT OPERATIONS DOFILE
	do "$do_master/04_external_combat_operations.do"


* 5. Merge historical background variables

do "$do_master/05_merge_EXTERNAL.do"


* 6. Construct variables

do "$do_master/06_comp_VARIABLES.do"


* 7. Produce tables

	* 7.1 TABLES
	do "$do_master/07_tables.do"

	* 7.2 TABLE 3 REQUIRES EXTERNAL DATA: SEX RATIO
	do "$do_master/07_table_3_sex_ratio.do"


* 8. Produce figures

	* 8.1 FIGURE 1: CASUALTIES, EXTERNAL DATA
	do "$do_master/08_figure_1_casualties.do"		
	
	* 8.2 FIGURE 2: REQUIRES PANEL SETUP
	do "$do_master/08_panel_setup.do"
	do "$do_master/08_figure_2_panel.do"
	
	* 8.3 FIGURE 3: MOVEMENTS, EXTERNAL DATA
	do "$do_master/08_figure_3_movement.do"		
	
	* 8.4 FIGURES 4 & 5: BASED ON SHARE DATA
	do "$do_master/08_figures_4_5.do"

	
* 9. Produce appendix

do "$do_master/09_appendix.do"


















	
	
	
	
	
	
	
	
	
	

