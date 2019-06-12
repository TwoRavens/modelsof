clear all
use data4election_rates.dta
set more off

gen aux=1
egen numero=sum(aux), by(TT year_bd)
* Registration Rates: Bandwidth of 1 day (180 bins)
gen tasa=(numero/total_nac)*100
collapse (mean) tasa numero total_nac, by(TT year_bd)

* Polynomial variables
gen TT2=TT*TT/100
gen TT3=TT*TT2/100
gen TT4=TT*TT3/100
gen D0=0
replace D0=1 if TT>0
gen D1=TT*D0
forval i=2(1)4{
gen D`i'=TT`i'*D0
}

*** Estimation
*************************************************
*** Polynomial Estimation
reg tasa TT TT2 D0 D1 D2, cluster(TT)
outreg2 using table0.txt, replace  dec(2)

***********************************************
*** ALL Elections
rdbwselect tasa TT  , c(1) bwselect(CCT) 
** ALL, tasa: h=36.81
reg tasa TT D0 D1 if TT>=-35&TT<=37, cluster(TT)
outreg2 using table0.txt, append  dec(2)

***********************************************
*** 1986 (2004)
rdbwselect tasa TT  if year_bd==1986, c(1) bwselect(CCT) 
** 1986, tasa: h=30.29
reg tasa TT D0 D1 if year_bd==1986&TT>=-29&TT<=31
outreg2 using table0.txt, append  dec(2)

***********************************************
*** 1987 (2005)
rdbwselect tasa TT  if year_bd==1987, c(1) bwselect(CCT) 
** 1987, tasa: h=20.83
reg tasa TT D0 D1 if year_bd==1987&TT>=-21&TT<=23
outreg2 using table0.txt, append  dec(2)

***********************************************
*** 1990 (2008)
rdbwselect tasa TT  if year_bd==1990, c(1) bwselect(CCT) 
** 1990, tasa: h=28.99
reg tasa TT D0 D1 if year_bd==1990&TT>=-27&TT<=29
outreg2 using table0.txt, append  dec(2)

***********************************************
*** 1991 (2009)
rdbwselect tasa TT  if year_bd==1991, c(1) bwselect(CCT) 
** 1991, tasa: h=30.56
reg tasa TT D0 D1 if year_bd==1991&TT>=-29&TT<=31
outreg2 using table0.txt, append  dec(2)





