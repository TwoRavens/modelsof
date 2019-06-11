clear all
use data4election_rates.dta
set more off

sort comuna
merge m:1 comuna using casen_quintiles
drop if _merge!=3
drop _merge

*** Count Registrations

count if quintile==1
count if quintile==2
count if quintile==3
count if quintile==4
count if quintile==5

count if quintile==1&TT>=-35&TT<=37
count if quintile==2&TT>=-35&TT<=37
count if quintile==3&TT>=-35&TT<=37
count if quintile==4&TT>=-35&TT<=37
count if quintile==5&TT>=-35&TT<=37

gen aux=1
egen numero=sum(aux), by(TT year_bd)
* Registration Rates: Bandwidth of 1 day (180 bins)
gen tasa=(numero/total_nac)*100
collapse (mean) tasa numero total_nac, by(TT year_bd quintile)

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

reg tasa TT TT2 D0 D1 D2 if quintile==1, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT TT2 D0 D1 D2 if quintile==2, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT TT2 D0 D1 D2 if quintile==3, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT TT2 D0 D1 D2 if quintile==4, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT TT2 D0 D1 D2 if quintile==5, cluster(TT)
outreg2 using table0.txt, append  dec(2)

reg tasa TT D0 D1 if quintile==1&TT>=-35&TT<=37, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT D0 D1 if quintile==2&TT>=-35&TT<=37, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT D0 D1 if quintile==3&TT>=-35&TT<=37, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT D0 D1 if quintile==4&TT>=-35&TT<=37, cluster(TT)
outreg2 using table0.txt, append  dec(2)
reg tasa TT D0 D1 if quintile==5&TT>=-35&TT<=37, cluster(TT)
outreg2 using table0.txt, append  dec(2)
