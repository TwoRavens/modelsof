clear
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"

/***********
Figures of sales by month and year
************/

use ..\data\toys_v1, clear

replace units = units/1000000
replace dollars = dollars/1000000

collapse (sum) units, by(year month)

*Calculate unit sales relative to January of that year
by year: gen units_reljan = units/units[1]

reshape wide units*, i(month) j(year)

lab define month 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
lab val month month

tw line units2005 units2006 units2007 month, legend(lab(1 2005) lab(2 2006) lab(3 2007) r(1))  ytitle("Units (1,000,000)") xtitle(Month) xlabel(1(1)12, val angle(45))
graph export ..\output\figure1A.tif, as(tif) replace

tw line units_reljan2005 units_reljan2006 units_reljan2007 month, legend(lab(1 2005) lab(2 2006) lab(3 2007) r(1))  ytitle("Units (Relative to January)") xtitle(Month) xlabel(1(1)12, val angle(45))
graph export  ..\output\figure1B.tif, as(tif) replace



