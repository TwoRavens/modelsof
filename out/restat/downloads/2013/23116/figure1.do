* make figure 1

set trace off
set more 1 
capture log close
clear
clear matrix
set mem 400m
set matsize 800
set linesize 200
version 9

log using figure1.log, replace


infile year quarter pcegas pcexgas using gasprice.txt, clear
replace year = year+1900
replace year = year+100 if year<=1950
gen time = year+quarter/4-.125

* the nominal price of gas in 2005 was $2.314
gen rpcegas = pcegas/pcexgas*2.314
sort time
lab var time " "
gr7 rpcegas time if year>=1970, c(l) s(.) xlab(1970(5)2010) ylab(1.2(.4)3.6) l1("2005 Dollars") saving(g1_new, replace)

quietly log close



