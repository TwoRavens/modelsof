/*
The data set INE_nationalaccounts_agr_x_ramas00_11_en.xls and was downloaded 
from http://www.ine.es/en/daco/daco42/cne00/dacocne_b10_en.htm  on January 11 
(section “National accounts”, “Aggregates by industry”). 
The sheet T_3, “Table 3, Gross value added at basic prices: current prices”, 
was then saved as INE_nationalaccounts_agr_x_ramas00_11_en.csv.
*/

insheet using "INE_nationalaccounts_agr_x_ramas00_11_en.csv", clear
drop in 1/7
drop v1 v3 v4 v5 v7 v9 v11 v13 v15 v17 v19 v21 v23 v25 v27 v29
cap drop v30
cap drop v31
cap drop v32
keep if v2!=""
rename v8 valu2000
rename v10 valu2001
rename v12 valu2002
rename v14 valu2003
rename v16 valu2004
rename v18 valu2005
rename v20 valu2006
rename v22 valu2007
rename v24 valu2008
rename v26 valu2009
rename v28 valu2010
foreach var of varlist valu* {
cap replace `var'=subinstr(`var',",","",.)
cap destring `var', replace
}
gen naceclio1=.
gen naceclio2=.
gen naceclio3=.
replace naceclio1=1 if v2=="10-12"
replace naceclio2=2 if v2=="10-12"
replace naceclio3=3 if v2=="10-12"
replace naceclio1=4 if v2=="13-15"
replace naceclio2=5 if v2=="13-15"
replace naceclio1=6 if v2=="16-18"
replace naceclio2=7 if v2=="16-18"
replace naceclio3=8 if v2=="16-18"
replace naceclio1=9 if v2=="20"
replace naceclio1=9 if v2=="21"
replace naceclio1=10 if v2=="22-23"
replace naceclio2=11 if v2=="22-23"
replace naceclio1=12 if v2=="24-25"
replace naceclio2=13 if v2=="24-25"
replace naceclio1=14 if v2=="28"
replace naceclio1=15 if v2=="26"
replace naceclio1=16 if v2=="27"
replace naceclio1=17 if v2=="29-30"
replace naceclio2=18 if v2=="29-30"
replace naceclio1=19 if v2=="31-33"
replace naceclio2=20 if v2=="31-33"
drop if naceclio1==.
drop v2 v6
collapse (sum) valu* , by(naceclio1 naceclio2 naceclio3)
reshape long valu, i(naceclio1 naceclio2 naceclio3) j(year)
drop if valu==.
reshape long naceclio , i(year valu) j(stub)
drop if naceclio==.
drop stub
label var naceclio "NACECLIO industry classification"
label var year "Year"
label var valu "Industry value added Spain"
keep if year>=2003
drop if year==2011
compress
order naceclio year valu
sort naceclio year
save "stanspain.dta", replace
