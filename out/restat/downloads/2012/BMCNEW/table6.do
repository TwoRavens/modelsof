clear
clear matrix
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"


*----------------------------------------------
* The impact of a recall on man-cat level sales by level of recall activity
*----------------------------------------------


use ..\data\man_cat_regdata, clear 

*By Recall Size (units)
areg log_u4 unbig*07 unsmall*07 hvrec*06 hvrec*05 _Iyear* if observations_u == 3, absorb(cell) robust
*---------------------------------
est store table61, title("units recalled")
*---------------------------------
ta unbig_man07 if observations_u == 3
ta unbig_man_cat07 if observations_u == 3
ta unsmall_man07 if observations_u == 3
ta unsmall_man_cat07 if observations_u == 3

*By Recall Size (value in dollars)
areg log_u4 valbig*07 valsmall*07 hvrec*06 hvrec*05 _Iyear* if observations_u == 3, absorb(cell) robust
*---------------------------------
est store table62, title("dollars recalled")
*---------------------------------
ta valbig_man07 if observations_u == 3
ta valbig_man_cat07 if observations_u == 3
ta valsmall_man07 if observations_u == 3
ta valsmall_man_cat07 if observations_u == 3




*By News Covereage
areg log_u4 newshigh*07 newsmed*07 newslow*07 hvrec*06 hvrec*05 _Iyear* if observations_u == 3, absorb(cell) robust
*---------------------------------
est store table63, title("news")
*---------------------------------

ta newshigh_man_cat07 if observations_u == 3
ta newshigh_man07 if observations_u == 3
ta newsmed_man_cat07 if observations_u == 3
ta newsmed_man07 if observations_u == 3
ta newslow_man_cat07 if observations_u == 3
ta newslow_man07 if observations_u == 3



estout table6* using ..\output\table6.csv, replace delimit(,) cells(b(star fmt(3)) se(par(`"="("' `")""'))) starlevels(* 0.10 ** 0.05) stats(N r2)
