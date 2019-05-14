*****************************************************
*FIGURES 4 - 7
*****************************************************

capture log close
clear 
cd "C:\Users\jenny\Desktop\Replication Office-selling\Main"

use main_part2_1, clear


**********
*Figure 4
**********

gen difprice = meanprice - minpriceh

binscatter lhhequiv difprice, reportreg

reg lhhequiv difprice, cluster(provincia)

*B=-0.39, se = 0.141, t = -2.78

**********
*Figure 5
**********

binscatter schoolyears difprice, reportreg 

reg schoolyears difprice, cluster(provincia)

*B=-1.43, se= 0.67, t = -2.12

**********
*Figure 6
**********

use main_part2_2, clear

gen difprice = meanprice - minpriceh

binscatter toilethouse difprice, reportreg

reg toilethouse difprice, cluster(provincia)

*B=-4.19, se=2.91, t=-1.44

**********
*Figure 7
**********

binscatter mud difprice, reportreg 

reg mud difprice, cluster(provincia)

*B=11.36, se=3.76, t=3.02



