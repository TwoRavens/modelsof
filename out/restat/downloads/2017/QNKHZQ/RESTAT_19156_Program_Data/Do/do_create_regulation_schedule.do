* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

**** [1] Read estimated coefficients as scalar variable

set scheme s1mono,perm
use $data/japan_mpg_regulation,clear
keep if weight<=2500
twoway || ///
line target_km_lit weight if period=="2006to2015" || ///
line target_km_lit weight if period=="1998to2010",lp(-) lc(black) || ///
, xlabel(600(200)2400) ylabel(,angle(0)) ytitle("Fuel economy (km per liter)") title("",size(normal)) ///
legend(order(1 "New standard (target year = 2015)" 2 "Old standard (target year = 2010)") size(small)) xtitle("Vehicle weight (kg)") ///
ylabel(6(1)23)
graph export $figure/japan_mpg_regulation.pdf,replace

*** END

