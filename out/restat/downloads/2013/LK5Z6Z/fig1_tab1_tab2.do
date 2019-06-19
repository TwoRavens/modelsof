clear all
set more off

*** insert location of directory containing files in place of DIRECTORY here:
cd "DIRECTORY"

log using fig1_tab1_tab2.txt, text replace

*** This .do file produces the results in Figure 1 and Table 1 of the paper.
*** The data set used is produced by gen_natality_data.do.

clear

use natality.dta

*** Figure 1:
*** These commands produce summary statistics by month-year
*** The resulting columns were copied into Excel to make the figures.
gen t=((year-1989)*12)+birthmon
tabstat married momwhite momHS teenmom, by(t)

*** Table 1:
gen tsq=t^2
gen tcu=t^3
compress
xi i.birthmon

reg married _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 
reg momwhite _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 
reg momHS _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 
reg teenmom _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 
reg birthwt _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 
reg lbw _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 
reg preterm _I* t tsq tcu, r
test _Ibirthmon_2 _Ibirthmon_3 _Ibirthmon_4 _Ibirthmon_5 _Ibirthmon_6 _Ibirthmon_7 _Ibirthmon_8 _Ibirthmon_9 _Ibirthmon_10 _Ibirthmon_11 _Ibirthmon_12 

drop _I*

*** Results for column 4 of Table 2

gen q2=birthmon>3 & birthmon<7
gen q3=birthmon>6 & birthmon<10
gen q4=birthmon>9 & birthmon<13
gen qtr=1
replace qtr=2 if q2==1
replace qtr=3 if q3==1
replace qtr=4 if q4==1
compress

drop t tsq tcu
gen t=((year-1989)*4)+qtr
drop qtr year
gen tsq=t^2
gen tcu=t^3
compress

sum momHS married momwhite teenmom

*** reg mom has HS degree qtr dummies
reg momHS q2 q3 q4 t tsq tcu, r
est store momHS
reg married q2 q3 q4 t tsq tcu, r
est store married
reg momwhite q2 q3 q4 t tsq tcu, r
est store momwhite

est table momHS married momwhite, b(%9.4f) se(%9.4f)

log close

