
capture log close
clear 
cd "C:\Users\jenny\Desktop\Replication Office-selling\Main"

**********
*Figure 8,9,10 Extraction and Composition of Indigenous Population over time
**********

use main_part2_2, clear

*keeping similar observations in all figures

gen sample = 0
replace sample = 1 if shindig80!=. & shindig !=.

**********
*Figure 8
**********

gen difprice = meanprice - minpriceh

binscatter shindig80 difprice if sample==1, reportreg

reg shindig80 difprice if sample==1, cluster(provincia)


**********
*Figure 9
**********

binscatter shindig difprice if sample==1, reportreg

reg shindig difprice if sample==1, cluster(provincia)


**********
*Figure 10
**********

use main_part2_2, clear

merge 1:m ubigeo using main_part2_1
drop _merge

gen sample = 0
replace sample = 1 if shindig80!=. & shindig !=.

gen difprice = meanprice - minpriceh

binscatter QUE difprice if sample==1, reportreg

reg QUE difprice if sample==1, cluster(provincia)
