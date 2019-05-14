
clear 
cd "C:\Users\jenny\Desktop\Replication Office-selling\Main"

use main_part1, clear

keep if audiencia=="Lima"

*real price of high and low repartimiento provinces
gen hprice = rprice1 if rep50==1
gen lprice = rprice1 if rep50==0

*obtaining yearly averages
bys year: egen avghprice = mean(hprice)
bys year: egen avglprice = mean(lprice)

*creating  difference
bys year: gen difprice = (avghprice) - (avglprice)

#delimit;
twoway (line difprice year, yaxis(2))
(scatter hprice year, sort)
(scatter lprice year, sort);
#delimit cr
