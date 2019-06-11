********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

* Open "2016 MTurk.dta"

********************************************************************************

*** Cleaning and recoding data ***

* Party ID
gen pid1 = q74 - 4
replace pid1 = . if q74 >= 8

gen pid2 = -3 if q29 == 1
replace pid2 = -2 if q29 == 2
replace pid2 = -1 if q30 == 2
replace pid2 = 0 if q27 == 3 & q30 == 3
replace pid2 = 1 if q30 == 1
replace pid2 = 2 if q28 == 2
replace pid2 = 3 if q28 == 1

egen pidcomb = rowmax(pid1 pid2)

gen rep = 1 if pid1 > 0 & pid1 < .
replace rep = 1 if pid2 > 0 & pid2< .
replace rep = 0 if pid1 < 0 | pid2 < 0


* Partisanship of conspiracies (1= Democrats, 2= Neither, 3= Republican)
gen birthercon = q72_1 
replace birthercon = . if q72_1 == 4
recode birthercon (2=3) (3=2)

gen jfkcon = q72_2 
replace jfkcon = . if q72_2 == 4
recode jfkcon (2=3) (3=2)

gen truthercon = q72_3 
replace truthercon = . if q72_3 == 4
recode truthercon (2=3) (3=2)

gen vaporcon = q72_4 
replace vaporcon = . if q72_4 == 4
recode vaporcon (2=3) (3=2)

gen iraqcon = q72_5 
replace iraqcon = . if q72_5 == 4
recode iraqcon (2=3) (3=2)

gen healthcarecon = q72_6 
replace healthcarecon = . if q72_6 == 4
recode healthcarecon (2=3) (3=2)

gen katrinacon = q72_7 
replace katrinacon = . if q72_7 == 4
recode katrinacon (2=3) (3=2)

gen warmingcon = q72_8 
replace warmingcon = . if q72_8 == 4
recode warmingcon (2=3) (3=2)


********************************************************************************

*** Empirical analysis ***

* Raw responses
tab birthercon
tab jfkcon
tab truthercon
tab vaporcon
tab iraqcon
tab healthcarecon
tab katrinacon
tab warmingcon2


* Responses by party identification (Table 1)
proportion birthercon if rep == 1
proportion birthercon if rep == 0

proportion jfkcon if rep == 1
proportion jfkcon if rep == 0

proportion truthercon if rep == 1
proportion truthercon if rep == 0

proportion vaporcon if rep == 1
proportion vaporcon if rep == 0

proportion iraqcon if rep == 1
proportion iraqcon if rep == 0

proportion healthcarecon if rep == 1
proportion healthcarecon if rep == 0

proportion katrinacon if rep == 1
proportion katrinacon if rep == 0

proportion warmingcon if rep == 1
proportion warmingcon if rep == 0
