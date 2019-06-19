	     *******************************************************
			****** Master Berman and Couttenier (2014) ******
			   *******************************************
			   
* Software: Stata 12 *		
clear all
set mem 5g
set matsize 8000
set maxvar  8000

ssc install distinct
ssc install geodist
ssc install estout

/* Change root folder directory here */
global dir "D:\Travail\Research\Berman_Couttenier_Restat\Data_Code_BC_Restat_2014"
*
global Data 		"$dir\Data\Source"
global Results 		"$dir\Results"
global Output_data  "$dir\Data\Output"
global Do_files     "$dir\Do_files"
*
cd "$dir"

************************
* ESTIMATIONS DO-FILES *
************************
*
/* Tables appearing in the main text */
do "$Do_files\Table_1_2.do"
do "$Do_files\Table_3_4.do"
do "$Do_files\Table_5.do"
do "$Do_files\Table_6.do"
do "$Do_files\Table_7.do"
do "$Do_files\Table_8_9.do"

/* Tables appearing in the appendix */
do "$Do_files\Table_10.do"
do "$Do_files\Table_11.do"
do "$Do_files\Table_12.do"

/* Tables appearing in the web appendix */
do "$Do_files\Table_A1.do"
do "$Do_files\Table_A3_to_A6.do"
do "$Do_files\Table_A7.do"
do "$Do_files\Table_A8.do"
do "$Do_files\Table_A9.do"
do "$Do_files\Table_A10.do"
do "$Do_files\Table_A11.do"
do "$Do_files\Table_A12.do"
do "$Do_files\Table_A13.do"
do "$Do_files\Table_A14_to_A25.do"
do "$Do_files\Table_A26_27.do"
do "$Do_files\Table_A28.do"
do "$Do_files\Table_A29.do"
do "$Do_files\Table_A30.do"
do "$Do_files\Table_A31.do"
do "$Do_files\Table_A32_33.do"
do "$Do_files\Table_A34.do"
do "$Do_files\Table_A35.do"
do "$Do_files\Figure_A7.do"
do "$Do_files\Figure_A8.do"
/*
*
*************************
* CONSTRUCTION DO-FILES *
*************************
*
global fao		    "$dir\Data\Source\FAO"
global crops		"$dir\Data\Source\CROPS"
global trade	    "$dir\Data\Source\trade_data"
*
do "$Do_files\1-Construct_trade_data.do"
do "$Do_files\2a-FAO_construct.do"
do "$Do_files\2b-FAO_construct_exporters.do"
do "$Do_files\2c-FAO_construct_macro.do"
do "$Do_files\2d-FAO_construct_power.do"
do "$Do_files\2e-FAO_construct_w0.do"
do "$Do_files\2f-FAO_construct_wbin.do"
do "$Do_files\3a-Crops_construct.do"
do "$Do_files\3b-GAEZ_construct.do"
do "$Do_files\4-Crises_exposure.do"
do "$Do_files\5-Agoa_constr.do"
do "$Do_files\6-Main_dataset_constr.do"
do "$Do_files\7-Crises_effects_constr.do"
*
*/
