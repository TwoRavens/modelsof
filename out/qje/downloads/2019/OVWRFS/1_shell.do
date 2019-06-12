
// first version: August 2016
// this version: February 2018

// WORKSHOP

clear all
macro drop _all
set more off
set mem 1000m
set seed 27062007
set matsize 11000
set maxvar 10000

// defines the reference folder
*global pc "/Users/mic965"
global pc "/Users/michela"

global root  "$pc/Dropbox/Gender_stereotypes/replication_data_QJE"
global codes   "$root/codes"
global output  "$root/output"
global trash   "$root/trash"
global data   "$root/dataset"

cd "$root"

*******************************************************************************
* RESULTS
*******************************************************************************
do "$codes/2_gender_stereotypes.do"  
do "$codes/3_appendix.do"  
do "$codes/4_teacher_questionnaire" //Figures 1, A.1, Tables 1, 3, A.2, A.4, C.1
do "$codes/5_robustness.do" //Figure A.V and Table A.12


*******************************************************************************
* OTHER NOTES
*******************************************************************************
* Data to produce Figures A.III and A.IV are the 2015 PISA scores
* Data to produce Table A.I can be downloaded from INVALSI website (create a free account and download them)
* Data on teacher-assigned grades and IAT/immigrants for Figure A.VII and A.XVIII will be available after the pubblication of Alesina, Carlana, La Ferrara, Pinotti, NBER WP 25333, while test score in grade 5 will be available after the publication of Carlana 2019 on value added.
