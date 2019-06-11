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


*Estimation

***********************************************
***************************** ALL ********************
rdbwselect numero TT  , c(1) bwselect(CCT) 
rdbwselect total_nac TT  , c(1) bwselect(CCT) 
** ALL, numero: h=40.88
** ALL, total_nac: h=26.80

** For regressions we use the largest bandwith

reg numero TT D0 D1 if TT>=-39&TT<=41, cluster(TT)
outreg2 using table0.txt, replace  dec(2)
reg total_nac TT D0 D1 if TT>=-39&TT<=41, cluster(TT)
outreg2 using table0.txt, append  dec(2)

***************************** PRESIDENTIAL ********************
rdbwselect numero TT  if year_bd==1987|year_bd==1991, c(1) bwselect(CCT) 
rdbwselect total_nac TT  if year_bd==1987|year_bd==1991, c(1) bwselect(CCT) 
** Presidential, numero: h=34.03
** Presidential, total_nac: h=18.53

reg numero TT D0 D1 if (year_bd==1987|year_bd==1991)&TT>=-33&TT<=35, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg total_nac TT D0 D1 if (year_bd==1987|year_bd==1991)&TT>=-33&TT<=35, cluster(TT)
outreg2 using table0.txt, append  dec(2)

***************************** MUNICIPAL ********************
rdbwselect numero TT  if year_bd==1986|year_bd==1990, c(1) bwselect(CCT) 
rdbwselect total_nac TT  if year_bd==1986|year_bd==1990, c(1) bwselect(CCT) 
** Municipal, numero: h=35.12
** Municipal, total_nac: h=32.24

reg numero TT D0 D1 if (year_bd==1986|year_bd==1990)&TT>=-34&TT<=36, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg total_nac TT D0 D1 if (year_bd==1986|year_bd==1990)&TT>=-34&TT<=36, cluster(TT)
outreg2 using table0.txt, append  dec(2)




