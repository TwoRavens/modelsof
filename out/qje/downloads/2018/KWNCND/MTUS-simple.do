use "../../MTUS/MTUS-simple.dta"

svyset [pweight=propwt]

drop if sex==-8

*country and year 
*12 = France (1998-99)
*13 = Germany (2001-02)
*18 = Italy (2002-03)
*22 = Netherlands (1995, 2000, 2005)
*24 = Norway (1990-1991, 2000-01)
*34 = Spain (2002-03, 2008-10)
*37 = UK (2000-01, 2005)

*select country and year
keep if countrya==37
keep if year>=2000 & year<=2005

*home work, leisure and work (added childcare and elderly care to homework, and eating & drinking to leisure)
generate homework = (foodprep + cleanetc + maintain + shopserv + garden + petcare + eldcare + pkidcare + ikidcare)*7/60
generate work = (paidwork + commute)*7/60
generate leisuretime = (sportex + tvradio + read + compint + goout + leisure + eatdrink)*7/60 

drop if missing(work)
drop if missing(homework)
drop if missing(leisuretime)
drop if work>100
drop if homework>100
drop if leisuretime==0

generate ratiohl=homework/(homework+leisuretime)

*age restriction
keep if age>=50 & age<=65

*means and standard deviations over age
svy: mean ratiohl if sex==1, over(age)
estat sd

svy: mean ratiohl if sex==2, over(age)
estat sd

tab age if sex==1
tab age if sex==2


