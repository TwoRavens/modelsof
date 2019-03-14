*! syntax BITrelated Democracyrelated


capture program drop leadergraph
program define leadergraph

#delimit ;

qui sum `1' if polity2<=-5 & polity2 != . , d ;
local max_bit_a=r(p95);

qui sum `1' if polity2>=5 & polity2 != . , d ;
local max_bit_d=r(p95);

qui sum `2';
local max_dem=9;
local min_dem=-9;

stcurve, hazard at1(`2'=`min_dem'  `1'=0 ) 
at2(`2'=`min_dem' `1'=0.693) 
at3(`2'=`min_dem' `1'=`max_bit_a')
range(0 25)
lcolor(black red blue green) 
clwidth(medthick medthick medthick medthick)
graphregion(fcolor(white)) ytitle(Hazard Rate) xtitle(Years in Office) 
scheme(s2mono) legend(label(1 No BIT) label(2 One BIT) label(3 Max BITs)) 
name(minpolity, replace) subtitle(Minimum Polity Score);
window manage close graph;

stcurve, hazard at1(`2'=`max_dem'  `1'=0) 
at2(`2'=`max_dem' `1'=0.693) 
at3(`2'=`max_dem' `1'=`max_bit_d')
range(0 25)
lcolor(black red blue green) 
clwidth(medthick medthick medthick medthick)
graphregion(fcolor(white)) ytitle(Hazard Rate) xtitle(Years in Office) 
scheme(s2mono) legend(label(1 No BIT) label(2 One BIT) label(3 Max BITs)) 
name(maxpolity, replace) subtitle(Maximum Polity Score);
window manage close graph;

graph combine minpolity maxpolity, ycommon graphregion(fcolor(white))
title(Estimated Hazard Rates);

#delimit cr
end
