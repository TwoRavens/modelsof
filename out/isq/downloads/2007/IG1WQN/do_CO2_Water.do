**ISQ 2006 CO2 and water pollution models

#delimit ;

use co2_water.dta, clear;
qui tab year, g(time);

*****all countries;

**MODELS REPORTED;
****co2*****************;
areg co2lead dem openc war  rgdpl rgdplsq popdense  co2 time*, robust absorb(cow);

areg co2lead demdum openc war  rgdpl rgdplsq popdense  co2  time*, robust absorb(cow);

areg co2lead autdum openc war  rgdpl rgdplsq popdense  co2 time*, robust absorb(cow);


*******water**********;
areg organicwaterloglead dem openc war  rgdpl rgdplsq popdense  organicwaterlog time*, robust absorb(cow);

areg organicwaterloglead demdum openc war  rgdpl rgdplsq popdense  organicwaterlog time*, robust absorb(cow);

areg organicwaterloglead autdum openc war  rgdpl rgdplsq popdense  organicwaterlog time*, robust absorb(cow);

 
