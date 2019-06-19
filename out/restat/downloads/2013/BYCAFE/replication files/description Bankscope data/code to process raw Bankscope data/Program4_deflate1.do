clear
set mem 500m
use Allelanden3.dta, clear

keep period banknr countrycode II totalrevenue Depositscustomers TA

gen deflator=0

replace deflator=1 	if period==1986 
replace deflator=1.037 	if period==1987 
replace deflator=1.079  if period==1988 
replace deflator=1.131  if period==1989 
replace deflator=1.192  if period==1990
replace deflator=1.243  if period==1991 
replace deflator=1.280	if period==1992  
replace deflator=1.318 	if period==1993 
replace deflator=1.352 	if period==1994	
replace deflator=1.390 	if period==1995 
replace deflator=1.431 	if period==1996
replace deflator=1.465  if period==1997 
replace deflator=1.487 	if period==1998
replace deflator=1.520 	if period==1999	
replace deflator=1.571  if period==2000 
replace deflator=1.616 	if period==2001
replace deflator=1.641 	if period==2002
replace deflator=1.679 	if period==2003
replace deflator=1.723 	if period==2004
replace deflator=1.748  if period==2005 
 
tab deflator

gen II_def=II/deflator
gen TI_def=totalrevenue/deflator
gen Depositscustomers_def=Depositscustomers/deflator

sum

save temp.dta, replace

insheet using CPI.csv, delimiter(";") clear
destring yr1986, replace
generate id =_n
reshape long yr, i(id) j(period) string
drop id
destring yr, replace
destring period, replace
rename yr inflation
label variable inflation "Inflation  (CPI)"
sort period countrycode
save cpi.dta, replace

use temp.dta, clear
sort period countrycode
merge period countrycode using cpi.dta, uniqusing nokeep
drop _merge

* drop countrycode country
drop   II totalrevenue Depositscustomers deflator TA
compress
saveold Datafile Laura v7.dta, replace

