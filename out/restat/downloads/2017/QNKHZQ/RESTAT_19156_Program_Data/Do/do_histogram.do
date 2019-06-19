* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

**** [1] Read estimated coefficients as scalar variable

use $data/histogram_regime0,clear
append using $data/japan_mpg_regulation,force

*** regime0

set scheme s1mono,perm
twoway ///
line target_km_lit weight if period=="1998to2010"& weight>=500 & weight<=2650,yaxis(1) lc(gs8)  || ///
histogram car_weight if type~="kei",start(500) w(10)  color(black) fraction disc  yaxis(2) || ///
, xlabel(600(200)2700) ylabel(6(1)23,angle(0)) ylabel(0(0.01)0.05,angle(0) axis(2)) legend(order(1 "Fuel Economy Standard" 2 "Density of Vehicles in the Market") size(small)) xline(710 830 1020 1270 1520 1770 2020 2270,lc(gs11) lp(-) lw(vthin )) ///
xtitle("Vehicle weight (kg)") ytitle("Fuel economy (km per liter)")  ytitle("Density",axis(2))
graph export $figure/histogram_regime0.pdf,replace

*** regime1

use $data/histogram_regime1,clear
append using $data/japan_mpg_regulation,force

twoway ///
line target_km_lit weight if period=="2006to2015" & weight>=500 & weight<=2700,yaxis(1) lc(gs8) || ///
histogram car_weight if type~="kei",start(500) w(10) color(black) fraction disc  yaxis(2) || ///
, xlabel(600(200)2600) ylabel(6(1)23,angle(0)) ylabel(0(0.01)0.05,angle(0) axis(2)) legend(order(1 "Fuel Economy Standard" 2 "Density of Vehicles in the Market") size(small)) xline(610 750 865 990 1090 1200 1320 1430 1540 1660 1770 1880 2000 2110 2280,lc(gs11) lp(-) lw(vthin ))  ///
xtitle("Vehicle weight (kg)") ytitle("Fuel economy (km per liter)")  ytitle("Density",axis(2))
graph export $figure/histogram_regime1.pdf,replace

*** END
