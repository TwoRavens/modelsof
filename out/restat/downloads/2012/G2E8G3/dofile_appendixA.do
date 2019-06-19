clear
capture log close
set more off
set memory 64m
set matsize 800

use data_appendixA.dta, clear

sort month year

by month: egen avprcp1=mean(prcp1)
by month: egen avprcp2=mean(prcp2)

gen stprcp1=(prcp1)/abs(avprcp1)
gen stprcp2=(prcp2)/abs(avprcp2)

sort month year
tsset month year

xtreg prcp2 prcp1, re

xtreg prcp2 prcp1, fe

xtreg stprcp2 stprcp1, re

xtreg stprcp2 stprcp1, fe

