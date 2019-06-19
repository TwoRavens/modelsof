clear
clear matrix
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"


*----------------------------------------------
* The impact of a recall on man-cat level sales
*----------------------------------------------


use ..\data\man_cat_regdata, clear 

*Baseline reg V2 - including man-cat and man recall vars
areg log_u4 hvrec*07 hvrec*06 hvrec*05 _Iyear_2007 _Iyear_2006 if observations_u == 3, absorb(cell) robust
*---------------------------------
est store table51, title(Baseline)
*---------------------------------
ta hvrec_man_cat07 if observations_u == 3
ta hvrec_man07 if observations_u == 3
ta hvrec_man_cat06 if observations_u == 3
ta hvrec_man06 if observations_u == 3
ta hvrec_man_cat05 if observations_u == 3
ta hvrec_man05 if observations_u == 3

*Add lead of 07 MAN and MAN-CAT recalls
areg log_u4 hvrec*07 hvrec*06 hvrec*05 t06Xhvrec*07 _Iyear_2007 _Iyear_2006 if observations_u == 3, absorb(cell) robust
*---------------------------------
est store table52, title(Pretrends)
*---------------------------------
test hvrec_man07=t06Xhvrec_man07
test hvrec_man_cat07=t06Xhvrec_man_cat07
test (hvrec_man07=t06Xhvrec_man07) (hvrec_man_cat07=t06Xhvrec_man_cat07)

*Baseline Regressions for Top 15 firms only
areg log_u4 hvrec*07 hvrec*06 hvrec*05 _Iyear_2007 _Iyear_2006 if observations_u == 3 & top15==1, absorb(cell) robust
*---------------------------------
est store table53, title("Top 15")
*---------------------------------

ta hvrec_man_cat07 if observations_u == 3 & top15==1
ta hvrec_man07 if observations_u == 3 & top15==1
ta hvrec_man_cat06 if observations_u == 3 & top15==1
ta hvrec_man06 if observations_u == 3 & top15==1
ta hvrec_man_cat05 if observations_u == 3 & top15==1
ta hvrec_man05 if observations_u == 3 & top15==1

estout * using ..\output\table5.csv, replace delimit(,) cells(b(star fmt(3)) se(par(`"="("' `")""'))) starlevels(* 0.10 ** 0.05) stats(N r2)
