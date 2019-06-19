
clear
insheet using ./dta/oilprice.txt

d
summ
** gen year = real(substr(date,1,4))

/**
 OLD CODE THAT MATCHED 
     AVG OIL PRICE 1969 WITH 1970 CENSUS
     AVG OIL PRICE 1979 WITH 1980 CENSUS
**/

**keep if year == 1969 | year == 1979 | year == 1989 | year == 1999
**bys year: egen oilprice = mean(value)

bys year: keep if _n == 1

** to match census!!
*gen year = year + 1

* 4-year moving-average
*rename oilprice oilprice_old
*sort year
/**
if ("`1'" == "ma4") {
  gen oilprice = (oilprice_old[_n] +oilprice_old[_n-1] + oilprice_old[_n-2] +oilprice_old[_n-3]) / 4
}
else {
  gen oilprice = oilprice_old[_n]
}
**/

sort year

gen oilprice_prev  = oilprice[_n - 1]
gen oilprice_prev2 = oilprice[_n - 2]
gen oilprice_prev3 = oilprice[_n - 3]
gen oilprice_prev4 = oilprice[_n - 4]
gen oilprice_prev5 = oilprice[_n - 5]
gen oilprice_prev6 = oilprice[_n - 6]
gen oilprice_prev7 = oilprice[_n - 7]

sort year
gen oilprice_max = oilprice
replace oilprice_max = max(oilprice_max, oilprice_max[_n-1])

keep year oilprice*
save ./dta/oilprice.dta, replace

list year oilprice*

exit



gen myn = _n



reg oilprice oilprice_prev 

gen log_oilprice = log(oilprice)

keep if year > 1976 & year < 1998

summ log_oilprice, det

gen log_oilprice_prev = log_oilprice[_n - 1]
reg log_oilprice log_oilprice_prev

gen oilprice_diff     = oilprice - oilprice[_n - 1]
gen log_oilprice_diff = log_oilprice - log_oilprice[_n - 1]

reg oilprice_diff
reg log_oilprice_diff

exit

replace year = 1969 if year == 1966
replace year = 1969 if year == 1967
replace year = 1969 if year == 1968

replace year = 1979 if year == 1976
replace year = 1979 if year == 1977
replace year = 1979 if year == 1978

replace year = 1989 if year == 1986
replace year = 1989 if year == 1987
replace year = 1989 if year == 1988

replace year = 1999 if year == 1996
replace year = 1999 if year == 1997
replace year = 1999 if year == 1998

keep if year == 1969 | year == 1979 | year == 1989 | year == 1999

bys year: egen oilprice = mean(value)
bys year: keep if _n == 1

replace year = year + 1
sort year
keep year oilprice
save oilprice.dta, replace
list year oilprice
