	     *******************************************************
			****** Master Caselli and Tesei (2015) ******
			   *******************************************
			   
* Software: Stata 13 *		
clear all
set mem 5g
set matsize 8000
set maxvar  8000

/* Change root folder directory here */
global dir "/Users/andreatesei/Dropbox/CT/FINAL/Data_Code_CT_Restat_2015"

global Do_files                  "$dir/do"
global Construction_do_files     "$dir/do/construction"
global Data 		             "$dir/Data/source"
global Output_aux                "$dir/Data/output/aux"
global Output_final              "$dir/Data/output/final"
global Futures                   "$dir/Data/source/fut"
global log                       "$dir/log"


************************
* ESTIMATIONS DO-FILES *
************************

/* Tables appearing in the main text */
do $Do_files/reg_main

/* Tables appearing in the web appendix */
do $Do_files/reg_wapp

/* Graphs appearing in the main text and in the web appendix */
do $Do_files/graphs



/*************************
* CONSTRUCTION DO-FILES *
*************************
*
do $Construction_do_files/makedata_ct
do $Construction_do_files/variables_main
do $Construction_do_files/variables_wapp


/*
do $Construction_do_files/gpi
