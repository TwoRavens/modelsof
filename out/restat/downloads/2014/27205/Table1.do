 clear all
set mem 500m



log using "C:\Old C Drive\F\INTIKAM2009\RESTAT\WEB_final\RESTATWEB\Table1.log",replace


use "C:\Old C Drive\F\INTIKAM2009\RESTAT\WEB_Final\RESTATWEB\Table1data1.dta"


*Table 1 is created here

preserve
collapse (mean) two_plus2 four_plus2 six_plus2  count_code (count) intikam2 [aw=w005],by(country)
list,noo sep(500) t
restore
