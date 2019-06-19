
clear
set type double, permanently
set more off



/*
*****************
** Prepare data files
*****************

** NOTE: Need access to AHA data files (see "Data_Access.txt")
*do aha.do

do makeoil.do

do prepare_hcfa.do

do cbp

do prepare_aha_cbp state
do tables_prep state

do prepare_aha_cbp esr
do tables_prep esr
*****************
*****************



*****************
** Create figures in main text
*****************
do graphs.do
 */


*****************
** Create tables in main text
*****************

** NOTE: also produces table 2
do table1.do

do table3_first_stage.do

do table4_main.do

do table5_alt_depvars



*****************
** Create appendix tables and figures
*****************
do run_APPENDIX.do

