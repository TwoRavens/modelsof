
clear
clear mata
set more off
set matsize 11000
set mem 700m
pause on

* Set paths here
global path = ""
cd "$path"

global Do = ""

do "$Do/step1_data_cleaning_21_clean.do"
do "$Do/step2_create_apppool_17_clean.do"
do "$Do/step3_create_regfile_29_clean.do"

***THIS FILE PRODUCES ALL RESULTS IN THE PAPER AND APPENDIX C TABLES AND FIGURES
do "$Do/step4_paper_regs_19_clean.do"

***THIS FILE PRODUCES APPENDIX A TABLES AND FIGURES
do "$Do/step5_data_appendix_13_clean.do"




