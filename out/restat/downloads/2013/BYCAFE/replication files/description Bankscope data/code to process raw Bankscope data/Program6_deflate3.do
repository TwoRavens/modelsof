clear
set mem 500m
use Allelanden3.dta, clear

keep period banknr countrycode countryname TA

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

gen TA_def=TA/deflator

label variable deflator "USD deflator 1986 = 100"

drop temp

compress
saveold Datafile Laura TA v7.dta, replace
